defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  alias Rumbl.User

  def new(conn, _params) do
    changeset = User.changeset(%User{}, :empty)
    render conn, "new.html", changeset: changeset
  end

  def index(conn, _params) do
    users = Repo.all(Rumbl.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Rumbl.User, id)
    render conn, "show.html", user: user
  end
end
