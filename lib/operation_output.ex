defmodule OperationOutput do
  alias Helpers.DecimalHelper

  def to_output(line_values) do
    line_values
    |> Enum.map(&~s({"tax": #{DecimalHelper.to_precision(&1.tax, exact: true)}}))
    |> Enum.join(", ")
  end
end
