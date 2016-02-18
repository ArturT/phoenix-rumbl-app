defmodule Rumbl.InfoSys.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    children = [
      worker(Rumbl.InfoSys, [], restart: :temporary)
    ]

    # That strategy doesn’t start any children. Instead, it waits for us to explicitly ask it to start a child process, handling any crashes just as a :one_for_one supervisor would.
    supervise children, strategy: :simple_one_for_one
  end
end
