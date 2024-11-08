defmodule AssetsFlow do
  @moduledoc """
  AssetsFlow application entrypoint
  """

  @doc """
  Main function of the application. Application entrypoint

  ## Examples

      iex> AssetsFlow.main()
      [{"operation":"buy", "unit-cost":10.00, "quantity": 10000}, {"operation":"sell", "unit-cost":20.00, "quantity": 5000}]
      [{"operation":"buy", "unit-cost":20.00, "quantity": 10000}, {"operation":"sell", "unit-cost":10.00, "quantity": 5000}]

      [{"tax":0.00}, {"tax":10000.00}]
      [{"tax":0.00}, {"tax":0.00}]
  """
  def main(_args \\ []) do
    InputReader.read_lines()
    |> Enum.map(&OperationInput.decode/1)
    |> Enum.map(&OperationResolver.resolve_line/1)
    |> Enum.map(&OperationOutput.to_output/1)
    |> Enum.map(&"[#{&1}]")
    |> Enum.each(&IO.puts/1)
  end
end
