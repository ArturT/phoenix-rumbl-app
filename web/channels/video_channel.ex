defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel

  def join("video:" <> video_id, _params, socket) do
    :timer.send_interval(5_000, :ping)
    {:ok, assign(socket, :video_id, video_id)}
  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push socket, "ping", %{count: count}

    {:noreply, assign(socket, :count, count + 1)}
  end
end
