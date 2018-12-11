defmodule AdventOfCode.Day8Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Day8

  @input [:code.priv_dir(:advent_of_code), "inputs", "day8.txt"]
         |> Path.join()
         |> File.read!()
         |> String.trim()

  describe "part one" do
    test "example" do
      input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2" |> Day8.parse_input()
      assert 138 == Day8.metadata_sum(input)
    end

    test "problem" do
      input = Day8.parse_input(@input)
      assert 40701 == Day8.metadata_sum(input)
    end
  end
end
