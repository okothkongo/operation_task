defmodule OperationTask.StockMarketProviderWebSocket do
  @moduledoc """
  This module interacts with Stock Market Provider websocket end point, which transmit new companies as they are available.The companies are the saved in the database and notifation sent to via email.
  """
  use WebSockex
  require Logger
  alias OperationTask.Companies
  alias OperationTask.Accounts

  @websocket_url Application.compile_env!(:operation_task, :stock_market_provider_websocket_url)

  def start_link() do
    WebSockex.start_link(@websocket_url, __MODULE__, nil)
  end

  @impl true
  def handle_connect(_conn, state) do
    Logger.info("The connection to server is successful")
    {:ok, state}
  end

  @impl true
  def handle_disconnect(_conn, state) do
    Logger.info("The server has been disconnected")
    {:ok, state}
  end

  @impl true
  def handle_frame({:text, message}, state) do
    %{"data" => companies} = Jason.decode!(message)

    case Companies.insert_all_companies(companies) do
      [ok: {_, nil}] ->
        spawn(fn -> Accounts.send_new_companies_email_notification(companies) end)
        :ets.insert(:companies_table, {"websocket_companies", companies})
        {:ok, state}

      _ ->
        {:ok, state}
    end
  end
end