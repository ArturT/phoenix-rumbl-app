defmodule Rumbl.Router do
  use Rumbl.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Rumbl.Auth, repo: Rumbl.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Rumbl do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    # order :new, :show does matter
    # thanks to that we will not catch new as :id in show action
    resources "/users", UserController, only: [:index, :new, :show, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/manage", Rumbl do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Rumbl do
  #   pipe_through :api
  # end
end
