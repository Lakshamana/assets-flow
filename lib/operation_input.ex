defmodule OperationInput do
  @moduledoc """
  Defines an operation struct contract with the following fields:

    - operation: the type of operation (buy or sell)
    - unit_cost: the cost of operation per unit (currency/float value)
    - quantity: quantity of units involved in the operation (integer value)
  """
  defstruct operation: nil, unit_cost: nil, quantity: nil

  defp parse_single_value(%{
         "unit-cost" => unit_cost,
         "operation" => operation,
         "quantity" => quantity
       }) do
    %OperationInput{
      operation: operation,
      unit_cost: unit_cost,
      quantity: quantity
    }
  end

  # Fallback for invalid JSON values
  defp parse_single_value(_) do
    raise RuntimeError, message: "Couldn't parse operation"
  end

  @doc """
  Parses a json-formatted data into a OperationInput struct.

  ## Examples

      iex> OperationInput.decode(~s({"operation": "buy", "unit-cost": 100.0, "quantity": 10}))
      {:ok, %OperationInput{operation: "buy", unit_cost: 100.0, quantity: 10}}

      iex> OperationInput.decode(~s({"operation": "buy", "unit-cost": 100.0, "quantity": 10}))
      {:ok, %OperationInput{operation: "buy", unit_cost: 100.0, quantity: 10}}

      iex> OperationInput.decode(~s("invalid"))
      RuntimeError, message: "Couldn't parse operation"
  """
  def decode(val) do
    case Jason.decode(val) do
      {:ok, parsed} ->
        if(is_list(parsed), do: parsed, else: [parsed])
        |> Enum.map(&parse_single_value/1)

      {:error, _} ->
        raise RuntimeError, message: "Couldn't parse operation"
    end
  end
end
