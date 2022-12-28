defmodule OperationTaskWeb.FallbackController do
  use OperationTaskWeb, :controller

  def call(conn, {:error, error}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(OperationTaskWeb.CompanyView)
    |> render("422.json", error: error)
  end
end
