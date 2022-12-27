defmodule OperationTask.Companies do
  @moduledoc """
  This module sanitize data from the api endpoint and inserts the into the db
  """

  @doc """
  The insert_all_companies_sync/1 function is useful for inserting multiple companies into the database in an asynchronous manner, allowing for faster performance.
  """
  @spec insert_all_companies(list(map)) :: {non_neg_integer(), nil | [term()]}
  def insert_all_companies(companies) do
    companies
    |> prepare_data()
    |> Task.async_stream(fn companies -> insert_all(companies) end)
    |> Enum.to_list()
  end

  defp prepare_data(companies) do
    companies
    |> format_data()
    |> Stream.chunk_every(7000)
  end

  defp insert_all(companies) do
    OperationTask.Repo.insert_all("companies", companies)
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
