defmodule AdventOfCode.Day6Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day6
  alias AdventOfCode.Day6

  @input [:code.priv_dir(:advent_of_code), "inputs", "day6.txt"]
         |> Path.join()
         |> File.read!()

  test "problem one" do
    assert 2342 == Day6.largest_bounded_zone(@input)
  end
end
