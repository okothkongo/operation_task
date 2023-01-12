defmodule OperationTaskWeb.NewCompaniesChannel do
  use OperationTaskWeb, :channel

  @impl true
  def join("companies:new_companies", _payload, socket) do
    send(self(), :join)
    {:ok, socket}
  end

  def handle_info(:join, socket) do
    send_to_client()
    {:noreply, socket}
  end

  @impl true
  def handle_info(:send_to_client, socket) do
    rest_api = ets_lookup("rest_api_companies")
    websocket = ets_lookup("websocket_companies")

    case rest_api ++ websocket do
      [] ->
        send_to_client()

        {:noreply, socket}

      companies ->
        spawn(fn ->
          clear_ets(websocket, "websocket_companies")
          clear_ets(websocket, "rest_api_companies")
        end)

        send_to_client()
        push(socket, "new_companies", %{companies: companies})

        {:noreply, socket}
    end
  end

  defp send_to_client do
    :timer.send_interval(10000, self(), :send_to_client)
  end

  defp ets_lookup(key) do
    case :ets.lookup(:companies_table, key) do
      [] -> []
      [{_key, []}] -> []
      [{_key, companies}] -> companies
    end
  end

  defp clear_ets(companies, key) do
    case companies do
      [] -> nil
      _ -> :ets.insert(:companies_table, {key, []})
    end
  end
end
