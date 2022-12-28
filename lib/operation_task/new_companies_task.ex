defmodule OperationTask.NewCompaniesTask do
  @moduledoc """
  This module perform task of check new companies from the Stock Market Provider API endpoint after every 4 hours
  and the data is the saved to the database.
  """
  use GenServer
  alias OperationTask.Accounts
  alias OperationTask.Companies
  alias OperationTask.StockMarketProviderApi
  alias OperationTask.Util

  def start_link(timestamp) do
    GenServer.start_link(__MODULE__, timestamp, name: __MODULE__)
  end

  @impl true
  def init(state) do
    timestamp = Util.current_timestamp()
    fetch_and_save_companies_data(state)

    get_next_fetch()
    {:ok, timestamp}
  end

  @impl true
  def handle_info(:fetch_companies_info, state) do
    timestamp = Util.current_timestamp()
    fetch_and_save_companies_data(state)

    get_next_fetch()
    {:noreply, timestamp}
  end

  defp get_next_fetch() do
    :timer.send_interval(60000 * 60 * 4, self(), :fetch_companies_info)
  end

  defp fetch_and_save_companies_data(timestamp) do
    with {:ok, companies} <- StockMarketProviderApi.fetch_companies_data(timestamp),
         [ok: {_, nil}] <- Companies.insert_all_companies(companies) do
      spawn(fn -> Accounts.send_new_companies_email_notification(companies) end)
      :ets.insert(:companies_table, {"rest_api_companies", companies})
    else
      error ->
        error
    end
  end
end
