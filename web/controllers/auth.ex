defmodule Rumbl.Auth do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(Rumbl.User, user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    # The step is extremely important and it protects us from session fixation attacks.
    # It tells Plug to send the session cookie back to the client with a different identifier, in case an attacker knew, by any chance, the previous one.
    |> configure_session(renew: true)
  end
end
