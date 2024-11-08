defmodule Helpers.DecimalHelper do
  @moduledoc """
  Provides adapter/helper functions to work with Decimal numbers.
  """

  @doc """
  Rounds a float number to a given precision.
  Expects:
    - a number (which can be a float or not)
    - `opts` keyword list with (default=[]):
      - `exact`: an exact flag (default is false) to return the result as a Decimal number
      - `precision`: a precision (default is 2)

  Returns the rounded number as a float or a Decimal number if exact is passed as `true`.

  ## Examples

    iex> Helpers.DecimalHelper.to_precision(2, [exact: false, precision: 3])
    2.0

    iex> Helpers.DecimalHelper.to_precision(2, [exact: true, precision: 3])
    Decimal.new("2.000")

    iex> Helpers.DecimalHelper.to_precision(2, [precision: 2])
    2.0

    iex> Helpers.DecimalHelper.to_precision(2)
    2.0
  """
  @spec to_precision(number(), exact: boolean(), precision: number()) :: number() | Decimal.t()

  def to_precision(number, opts \\ [])

  def to_precision(number, opts) when is_float(number) do
    exact = Keyword.get(opts, :exact, false)
    precision = Keyword.get(opts, :precision, 2)

    result =
      number
      |> Decimal.from_float()
      |> Decimal.round(precision)

    if(exact, do: result, else: Decimal.to_float(result))
  end

  def to_precision(number, opts) do
    exact = Keyword.get(opts, :exact, false)
    precision = Keyword.get(opts, :precision, 2)

    case Decimal.cast(number) do
      {:ok, n} ->
        result =
          n
          |> Decimal.round(precision)

        if(exact, do: result, else: Decimal.to_float(result))

      _ ->
        raise ArgumentError, message: "Invalid number"
    end
  end
end
