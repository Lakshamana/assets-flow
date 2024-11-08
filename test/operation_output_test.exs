defmodule OperationOutputTest do
  use ExUnit.Case
  alias OperationOutput

  describe "to_output/1" do
    test "formats a single tax value" do
      line_values = [%{tax: 100.12345}]
      expected_output = ~s({"tax": 100.12})
      assert OperationOutput.to_output(line_values) == expected_output
    end

    test "formats multiple tax values" do
      line_values = [%{tax: 100.12345}, %{tax: 200.6789}]
      expected_output = ~s({"tax": 100.12}, {"tax": 200.68})
      assert OperationOutput.to_output(line_values) == expected_output
    end

    test "handles empty list of operations" do
      line_values = []
      assert OperationOutput.to_output(line_values) == ""
    end

    test "formats tax value of zero" do
      line_values = [%{tax: 0.0}]
      expected_output = ~s({"tax": 0.00})
      assert OperationOutput.to_output(line_values) == expected_output
    end

    test "formats negative tax value" do
      line_values = [%{tax: -100.12345}]
      expected_output = ~s({"tax": -100.12})
      assert OperationOutput.to_output(line_values) == expected_output
    end

    test "formats multiple tax values from the same operation" do
      line_values = [%{tax: 100.12345}, %{tax: 50.6789}]
      expected_output = ~s({"tax": 100.12}, {"tax": 50.68})
      assert OperationOutput.to_output(line_values) == expected_output
    end

    test "formats multiple operations with different taxes" do
      line_values = [
        %{tax: 100.12345},
        %{tax: 200.6789},
        %{tax: 0.98765}
      ]

      expected_output = ~s({"tax": 100.12}, {"tax": 200.68}, {"tax": 0.99})
      assert OperationOutput.to_output(line_values) == expected_output
    end
  end
end
