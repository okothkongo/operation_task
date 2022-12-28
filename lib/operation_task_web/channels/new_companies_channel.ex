defmodule OperationTaskWeb.NewCompaniesChannel do
  use OperationTaskWeb, :channel

  @impl true
  def join("companies:new_companies", _payload, socket) do
    rest_api = ets_lookup("rest_api_companies")
    websocket = ets_lookup("websocket_companies")

    case rest_api ++ websocket do
      [] ->
        {:ok, socket}

      companies ->
        send(self(), {:new_companies, companies})

        spawn(fn ->
          clear_ets(websocket, "websocket_companies")
          clear_ets(websocket, "rest_api_companies")
        end)

        {:ok, socket}
    end
  end

  @impl true
  def handle_info({:new_companies, companies}, socket) do
    push(socket, "new_companies", %{companies: companies})
    {:noreply, socket}
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
