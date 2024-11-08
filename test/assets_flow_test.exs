defmodule AssetsFlowTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "main" do
    input = """
    [{"operation":"buy", "unit-cost":10.00, "quantity": 10000}, {"operation":"sell", "unit-cost":20.00, "quantity": 5000}]
    [{"operation":"buy", "unit-cost":20.00, "quantity": 10000}, {"operation":"sell", "unit-cost":10.00, "quantity": 5000}]
    """

    {_, output} =
      with_io(input, fn ->
        task = Task.async(&AssetsFlow.main/0)
        Task.await(task)
      end)

    assert output == """
           [{"tax": 0.00}, {"tax": 10000.00}]
           [{"tax": 0.00}, {"tax": 0.00}]
           """
  end
end
