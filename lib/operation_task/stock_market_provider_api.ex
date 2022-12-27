defmodule OperationTask.StockMarketProviderApi do
  @moduledoc """
  Provide functions to interact with  Stock Market Provider HTTP API endpiont for
  listing new available companies.
  The Mock can be found at https://github.com/okothkongo/mock_stock_provider_and_client
  """
  use Tesla, only: [:get], docs: false

  plug Tesla.Middleware.BaseUrl,
       Application.fetch_env!(:operation_task, :stock_market_provider_api_url)

  plug Tesla.Middleware.JSON

  @doc """
  This function fetches new companies data using latest timestamp from the  endpoint and returns a tuple of :ok and list of maps(companies).
  """
  @spec fetch_companies_data(String.t()) :: {:ok, list(map)}
  def fetch_companies_data(timestamp) do
    with {:ok, body} <- "/companies/#{timestamp}" |> get() |> handle_response() do
      {:ok, body["data"]}
    end
  end

  defp handle_response({:ok, %Tesla.Env{body: body, status: status}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, response}),
    do: {:error, "Failed to  with #{inspect(response)}"}

  defp handle_response({:error, reason}),
    do: {:error, "Failed to  with #{inspect(reason)}"}
end
