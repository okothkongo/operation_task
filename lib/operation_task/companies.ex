defmodule OperationTask.Companies do
  @moduledoc """
  This module sanitize data from the api endpoint and inserts the into the db
  """
  import Ecto.Query, only: [from: 2]
  alias OperationTask.Repo
  alias OperatioTask.Companies.Company

  @doc """
  The insert_all_companies/1 function is useful for inserting multiple companies into the database in an asynchronous manner, allowing for faster performance.
  """
  @spec insert_all_companies(list(map)) :: {non_neg_integer(), nil | [term()]}
  def insert_all_companies(companies) do
    companies
    |> prepare_data()
    |> Task.async_stream(fn companies -> insert_all(companies) end)
    |> Enum.to_list()
  end

  @doc """
   Returns a list of companies in the database
  """
  @spec list_companies :: list()
  def list_companies do
    Repo.all(Company)
  end

  @doc """
   Return a list companies whose inserted_at is equal to or greater that given timestamp
  """
  @spec get_latest_companies(String.t()) :: list(map) | {:error, :invalid_date_time_format}
  def get_latest_companies(timestamp) do
    case NaiveDateTime.from_iso8601(timestamp) do
      {:ok, datetime} ->
        {:ok,
         datetime
         |> latest_companies_query()
         |> Repo.all()}

      _error ->
        {:error, :invalid_date_time_format}
    end
  end

  defp latest_companies_query(timestamp) do
    from(c in Company, where: c.inserted_at >= ^timestamp)
  end

  defp prepare_data(companies) do
    companies
    |> format_data()
    |> Stream.chunk_every(7000)
  end

  defp insert_all(companies) do
    Repo.insert_all("companies", companies)
  end

  defp format_data(all_companies) do
    Stream.map(all_companies, fn companies ->
      convert_map_keys_to_atom(companies)
    end)
  end

  defp convert_map_keys_to_atom(companies) do
    Enum.map(companies, fn {key, value} -> {String.to_atom(key), value} end) |> Enum.into(%{})
  end
end
