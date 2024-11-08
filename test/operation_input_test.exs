defmodule OperationInputTest do
  use ExUnit.Case
  alias OperationInput

  describe "parse/1" do
    test "parses a valid JSON string with standard keys" do
      json_input = ~s({"operation": "buy", "unit-cost": 100.0, "quantity": 10})

      assert OperationInput.decode(json_input) ==
               [%OperationInput{operation: "buy", unit_cost: 100.0, quantity: 10}]
    end

    test "parses a valid JSON string with hyphenated unit-cost" do
      json_input = ~s({"operation": "buy", "unit-cost": 100.0, "quantity": 10})

      assert OperationInput.decode(json_input) ==
               [%OperationInput{operation: "buy", unit_cost: 100.0, quantity: 10}]
    end

    test "parses multiple valid JSON objects" do
      json_input =
        ~s([{"operation": "buy", "unit-cost": 100.0, "quantity": 10}, {"operation": "sell", "unit-cost": 200.0, "quantity": 5}])

      expected = [
        %OperationInput{operation: "buy", unit_cost: 100.0, quantity: 10},
        %OperationInput{operation: "sell", unit_cost: 200.0, quantity: 5}
      ]

      assert OperationInput.decode(json_input) == expected
    end

    test "raises an error for invalid JSON input" do
      json_input = ~s("invalid")

      assert_raise RuntimeError, "Couldn't parse operation", fn ->
        OperationInput.decode(json_input)
      end
    end

    test "raises an error for malformed JSON input" do
      json_input = ~s({"operation": "buy", "unit-cost": 100.0, "quantity": })

      assert_raise RuntimeError, "Couldn't parse operation", fn ->
        OperationInput.decode(json_input)
      end
    end

    test "handles empty JSON array" do
      json_input = ~s([])
      assert OperationInput.decode(json_input) == []
    end
  end
end
