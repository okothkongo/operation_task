defmodule OperationTask.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @children [
    OperationTask.Repo,
    {OperationTask.NewCompaniesTask, OperationTask.Util.current_timestamp()},
    {Phoenix.PubSub, name: OperationTask.PubSub},
    OperationTaskWeb.Endpoint
  ]
  @impl true
  def start(_type, _args) do
    children =
      @children ++
        Application.get_env(
          :operation_task,
          :websocket_client
        )

    :ets.new(:companies_table, [:set, :named_table, :public])
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OperationTask.Supervisor]
    handle_websockex_start_refusal(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OperationTaskWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp handle_websockex_start_refusal(children, opts) do
    case Supervisor.start_link(children, opts) do
      {:error,
       {:shutdown,
        {:failed_to_start_child, OperationTask.StockMarketProviderWebSocket,
         %{args: [%{reason: %{original: :econnrefused}}, []]}}}} ->
        Supervisor.start_link(@children, opts)

      {:ok, pid} ->
        {:ok, pid}
    end
  end
end
