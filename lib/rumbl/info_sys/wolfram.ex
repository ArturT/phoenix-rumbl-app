defmodule Rumbl.InfoSys.Wolfram do
  import SweetXml
  alias Rumbl.InfoSys.Result

  # You might have spotted the start_link, but still, our module doesn’t have all of the ceremony that
  # you might have expected out of a GenServer. That’s because this process is just a task.
  # Because GenServer are meant to be generic servers, they hold both computation and state.
  # However, in many cases, we want a process only to store state or just to execute a particular function.
  # We have seen how an agent is a simple GenServer that manages state.
  # A task is a simple process that executes the given function.
  def start_link(query, query_ref, owner, limit) do
    Task.start_link(__MODULE__, :fetch, [query, query_ref, owner, limit])
  end

  def fetch(query_str, query_ref, owner, _limit) do
    query_str
    |> fetch_xml()
    |> xpath(~x"/queryresult/pod[contains(@title, 'Result') or contains(@title, 'Definitions')]/subpod/plaintext/text()")
    |> send_results(query_ref, owner)
  end

  # we want to send our results back to the requester. Remember the client is waiting on our results,
  # and we have the pid for that caller in owner
  defp send_results(nil, query_ref, owner) do
    send(owner, {:results, query_ref, []})
  end

  defp send_results(answer, query_ref, owner) do
    results = [%Result{backend: "wolfram", score: 95, text: to_string(answer)}]
    send(owner, {:results, query_ref, results})
  end

  defp fetch_xml(query_str) do
    {:ok, {_, _, body}} = :httpc.request(
      String.to_char_list(
        "http://api.wolframalpha.com/v2/query" <>
        "?appid=#{app_id()}" <>
        "&input=#{URI.encode(query_str)}&format=plaintext"
      )
    )
    body
  end

  defp app_id, do: Application.get_env(:rumbl, :wolfram)[:app_id]
end
