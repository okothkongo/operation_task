defmodule OperationTaskWeb.NewCompaniesChannelTest do
  use OperationTaskWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      OperationTaskWeb.CompanySocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(OperationTaskWeb.NewCompaniesChannel, "companies:new_companies")

    %{socket: socket}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end
