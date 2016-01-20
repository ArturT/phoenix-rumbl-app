defmodule Rumbl.Repo do
  use Ecto.Repo, otp_app: :rumbl

  @moduledoc """
  In memory repository.
  """

  #def all(Rumbl.User) do
    #[
      #%Rumbl.User{id: "1", name: "Jan", username: "janek", password: "elixir"},
      #%Rumbl.User{id: "2", name: "Tomasz", username: "tomek", password: "tom"},
      #%Rumbl.User{id: "3", name: "Krzysztof", username: "kris", password: "phx"}
    #]
  #end

  #def all(_module), do: []

  #def get(module, id) do
    #all(module)
    #|> Enum.find(fn map -> map.id == id end)
  #end

  #def get_by(module, params) do
    #all(module)
    #|> Enum.find(fn map ->
      #params
      #|> Enum.all?(fn {key, val} ->
        #Map.get(map, key) == val
      #end)
    #end)
  #end
end
