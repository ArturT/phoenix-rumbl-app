defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel

  def join("video:" <> video_id, _params, socket) do
    video = Repo.get!(Rumbl.Video, video_id)
    annotations = Repo.all(from a in assoc(video, :annotations),
    order_by: [desc: a.at],
    limit: 200,
    preload: [:user])

    resp = %{annotations: Phoenix.View.render_many(annotations, Rumbl.AnnotationView, "annotation.json")}

    {:ok, resp, assign(socket, :video_id, video_id)}
  end

  def handle_in(event, params, socket) do
    user = Repo.get(Rumbl.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    video_id = String.to_integer(socket.assigns.video_id)
    changeset =
      user
      |> build_assoc(:annotations, video_id: video_id)
      |> Rumbl.Annotation.changeset(params)

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        broadcast_annotation(socket, annotation)
        # We have used Task.start_link because we don’t care about the Task result. It’s important that we use a Task here so we don’t block on any particular messages arriving to the channel.
        Task.start_link(fn -> compute_additional_info(annotation, socket) end)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  defp broadcast_annotation(socket, annotation) do
    annotation = Repo.preload(annotation, :user)
    rendered_ann = Phoenix.View.render(Rumbl.AnnotationView, "annotation.json", %{annotation: annotation})
    broadcast! socket, "new_annotation", rendered_ann
  end

  defp compute_additional_info(ann, socket) do
    for result <- Rumbl.InfoSys.compute(ann.body, limit: 1, timeout: 10_000) do
      attrs = %{url: result.url, body: result.text, at: ann.at}
      info_changeset =
        Repo.get_by!(Rumbl.User, username: result.backend)
        |> build_assoc(:annotations, video_id: ann.video_id)
        |> Rumbl.Annotation.changeset(attrs)

      case Repo.insert(info_changeset) do
        {:ok, info_ann} -> broadcast_annotation(socket, info_ann)
        {:error, _changeset} -> :ignore
      end
    end
  end
end
