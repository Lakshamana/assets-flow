defmodule Helpers.DecimalHelperTest do
  use ExUnit.Case
  alias Helpers.DecimalHelper

  describe "to_precision/2" do
    test "rounds a float number to the specified precision and returns a float" do
      assert DecimalHelper.to_precision(2.34567, [precision: 3]) == 2.346
      assert DecimalHelper.to_precision(2.34567, [precision: 2]) == 2.35
      assert DecimalHelper.to_precision(2.3, [precision: 1]) == 2.3
      assert Float.to_string(DecimalHelper.to_precision(2.3, [precision: 2])) == "2.3"
    end

    test "rounds a float number to the specified precision and returns a Decimal when exact is true" do
      assert DecimalHelper.to_precision(2.34567, [exact: true, precision: 3]) == Decimal.new("2.346")
      assert DecimalHelper.to_precision(2.34567, [exact: true, precision: 2]) == Decimal.new("2.35")
      assert DecimalHelper.to_precision(2.3, [exact: true, precision: 2]) == Decimal.new("2.30")
    end

    test "returns the number as is if no options are provided" do
      assert DecimalHelper.to_precision(2) == 2.0
      assert DecimalHelper.to_precision(2.0) == 2.0
      assert DecimalHelper.to_precision(Decimal.new("2")) == 2.0
    end

    test "raises an error for invalid number input" do
      assert_raise ArgumentError, "Invalid number", fn ->
        DecimalHelper.to_precision("invalid")
      end

      assert_raise ArgumentError, "Invalid number", fn ->
        DecimalHelper.to_precision(nil)
      end
    end
  end
end

