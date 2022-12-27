defmodule OperationTask.Util do
  @doc """
  This function return current date time is iso8601 format
  """
  @spec current_timestamp :: String.t()
  def current_timestamp do
    NaiveDateTime.utc_now() |> NaiveDateTime.to_iso8601()
  end
end
