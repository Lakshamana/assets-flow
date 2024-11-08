defmodule InputReaderTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "mock stdin input" do
    input = """
    1st line
    2nd line
    3rd line
    """

    {result, _} =
      with_io(input, fn ->
        task = Task.async(&InputReader.read_lines/0)
        Task.await(task)
      end)

    assert result == ["1st line", "2nd line", "3rd line"]
  end
end
