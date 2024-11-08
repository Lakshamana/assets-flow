defmodule OperationResolverTest do
  use ExUnit.Case
  alias OperationResolver
  alias OperationInput

  describe "resolve_line/1" do
    test "Case 0: First input set" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 10.00, quantity: 10000},
        %OperationInput{operation: "sell", unit_cost: 20.00, quantity: 5000}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 10000.00}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end

    test "Case 0: Second input set" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 20.00, quantity: 10000},
        %OperationInput{operation: "sell", unit_cost: 10.00, quantity: 5000}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 0.00}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end

    test "Case 1: Multiple sell operations with no tax" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 10.00, quantity: 100},
        %OperationInput{operation: "sell", unit_cost: 15.00, quantity: 50},
        %OperationInput{operation: "sell", unit_cost: 15.00, quantity: 50}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 0.00}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end

    test "Case 2: Profit tax calculation on first sell" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 10.00, quantity: 10000},
        %OperationInput{operation: "sell", unit_cost: 20.00, quantity: 5000},
        %OperationInput{operation: "sell", unit_cost: 5.00, quantity: 5000}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 10000.00},
        %{tax: 0.00}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end

    test "Case 3: Tax calculation for sell operations based on profit" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 10.00, quantity: 10000},
        %OperationInput{operation: "sell", unit_cost: 5.00, quantity: 5000},
        %OperationInput{operation: "sell", unit_cost: 20.00, quantity: 3000}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 1000.00}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end

    test "Case 4: Multiple buys and a sell with no tax" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 10.00, quantity: 10000},
        %OperationInput{operation: "buy", unit_cost: 25.00, quantity: 5000},
        %OperationInput{operation: "sell", unit_cost: 15.00, quantity: 10000}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 0.00}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end

    test "Case 5: Mixed buy and sell operations with one tax" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 10.00, quantity: 10000},
        %OperationInput{operation: "buy", unit_cost: 25.00, quantity: 5000},
        %OperationInput{operation: "sell", unit_cost: 15.00, quantity: 10000},
        %OperationInput{operation: "sell", unit_cost: 25.00, quantity: 5000}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 10000.00}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end

    test "Case 6: Complex sequence of buy and sell operations" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 10.00, quantity: 10000},
        %OperationInput{operation: "sell", unit_cost: 2.00, quantity: 5000},
        %OperationInput{operation: "sell", unit_cost: 20.00, quantity: 2000},
        %OperationInput{operation: "sell", unit_cost: 20.00, quantity: 2000},
        %OperationInput{operation: "sell", unit_cost: 25.00, quantity: 1000}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 3000.00}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end

    test "Case 7: Larger sequence with varied operations" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 10.00, quantity: 10000},
        %OperationInput{operation: "sell", unit_cost: 2.00, quantity: 5000},
        %OperationInput{operation: "sell", unit_cost: 20.00, quantity: 2000},
        %OperationInput{operation: "sell", unit_cost: 20.00, quantity: 2000},
        %OperationInput{operation: "sell", unit_cost: 25.00, quantity: 1000},
        %OperationInput{operation: "buy", unit_cost: 20.00, quantity: 10000},
        %OperationInput{operation: "sell", unit_cost: 15.00, quantity: 5000},
        %OperationInput{operation: "sell", unit_cost: 30.00, quantity: 4350},
        %OperationInput{operation: "sell", unit_cost: 30.00, quantity: 650}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 3000.00},
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 3700.00},
        %{tax: 0.00}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end

    test "Case 8: Buy and sell with high margins" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 10.00, quantity: 10000},
        %OperationInput{operation: "sell", unit_cost: 50.00, quantity: 10000},
        %OperationInput{operation: "buy", unit_cost: 20.00, quantity: 10000},
        %OperationInput{operation: "sell", unit_cost: 50.00, quantity: 10000}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 80000.00},
        %{tax: 0.00},
        %{tax: 60000.00}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end

    test "Case 9: Edge case with extreme pricing" do
      operations = [
        %OperationInput{operation: "buy", unit_cost: 20.00, quantity: 10},
        %OperationInput{operation: "buy", unit_cost: 10.00, quantity: 5},
        %OperationInput{operation: "sell", unit_cost: 10.00, quantity: 5},
        %OperationInput{operation: "sell", unit_cost: 5000.00, quantity: 10}
      ]

      expected_output = [
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 0.00},
        %{tax: 9959.990000000002}
      ]

      assert OperationResolver.resolve_line(operations) == expected_output
    end
  end
end
