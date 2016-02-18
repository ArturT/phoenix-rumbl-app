# Rumbl

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

# Tips

## How to create users

    $ iex -S mix

    iex(1)> alias Rumbl.Repo
    iex(2)> alias Rumbl.User
    iex(3)> Repo.insert(%User{name: "Jose", username: "josevalim", password_hash: "<3<3elixir"})
    iex(4)> Repo.insert(%User{name: "Bruce", username: "redrapids", password_hash: "7langs"})
    iex(5)> Repo.insert(%User{name: "Chris", username: "chrismccord", password_hash: "phx"})

## Set up credentials

    $ cp config/dev.secret.exs.example config/dev.secret.exs

* Visit https://developer.wolframalpha.com/portal/signup.html
* Sign-in and click the “Get an AppID” link
* Enter your Application name and description, and submit the form
* Copy the generated APPID after submitting the form
* Add APPID to `config/dev.secret.exs`

## Seeds

Create wolfram bot user.

    $ mix run priv/repo/backend_seeds.exs
