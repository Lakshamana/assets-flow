defmodule InputReader do
  @moduledoc """
  Provides a way to read lines from standard input in a ordered way
  """

  @doc """
  Read lines from stdin until an empty line is found and return them as a list of strings
  in the order they were read

  ## Examples

    iex> InputReader.read_lines
    1st line
    2nd line
    3rd line

    ["1st line", "2nd line", "3rd line"]

    iex> InputReader.read_lines

    []
  """
  @spec read_lines() :: [String.t()]
  def read_lines, do: read_lines([])

  defp read_lines(acc_lines) do
    case IO.gets("") do
      "\n" ->
        acc_lines
        |> Enum.reverse()

      :eof ->
        acc_lines |> Enum.reverse()

      line ->
        read_lines([
          line |> String.trim()
          | acc_lines
        ])
    end
  end
end
