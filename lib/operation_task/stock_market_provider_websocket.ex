defmodule OperationTask.StockMarketProviderWebSocket do
  @moduledoc """
  This module interacts with Stock Market Provider websocket end point, which transmit new companies as they are available.The companies are the saved in the database and notifation sent to via email.
  """

  use GenServer
  require Logger

  alias OperationTask.Accounts
  alias OperationTask.Companies

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  @path Application.compile_env(:operation_task, :websocket_path)
  @port Application.compile_env(:operation_task, :websocket_port)
  @host Application.compile_env(:operation_task, :websocket_host)

  @connect_opts %{
    connect_timeout: :timer.minutes(1),
    retry: 10,
    retry_timeout: 100
  }

  def start_link(_state) do
    GenServer.start_link(__MODULE__, server_details(), name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state, {:continue, :connect}}
  end

  @impl true
  def handle_continue(:connect, state) do
    {:ok, gun_pid} = :gun.open(state.host, state.port, @connect_opts)
    wait_up(state, gun_pid)
  end

  @impl true
  def handle_continue(:upgrade, state) do
    :gun.ws_upgrade(state.gun_pid, state.path, [])
    {:noreply, state}
  end

  @impl true
  def handle_info({:gun_upgrade, _pid, _stream, _protocols, _headers}, state) do
    Logger.info("Websocket connection sucessful")
    {:noreply, state}
  end

  @impl true
  def handle_info(
        {:gun_ws, _pid, _ref, {:text, data}},
        state
      ) do
    %{"data" => companies} = Jason.decode!(data)

    case Companies.insert_all_companies(companies) do
      [ok: {_, nil}] -> spawn(fn -> Accounts.send_new_companies_email_notification(companies) end)
      _ -> nil
    end

    {:noreply, state}
  end

  @impl true
  def handle_info({:gun_down, _pid, :ws, :normal, _, _}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info({:gun_down, _pid, :ws, :closed, _, _}, state) do
    Logger.warn("Websocket server is not available the connection has been closed")
    {:noreply, state}
  end

  defp wait_up(state, gun_pid) do
    case :gun.await_up(gun_pid) do
      {:ok, _} ->
        {:noreply, Map.put(state, :gun_pid, gun_pid), {:continue, :upgrade}}

      error ->
        Logger.warn("Websocket server is not available due to #{inspect(error)}")
        {:noreply, state}
    end
  end

  defp server_details do
    %{path: to_charlist(@path), port: String.to_integer(@port), host: to_charlist(@host)}
  end
end
