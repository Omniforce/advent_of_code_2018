defmodule AdventOfCode.Day1Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Day1

  @input [:code.priv_dir(:advent_of_code), "inputs", "day1.txt"]
         |> Path.join()
         |> File.read!()
         |> String.split("\n", trim: true)
         |> Enum.map(&String.to_integer/1)

  describe "part one" do
    test "examples" do
      assert Day1.part_one([0, 1]) == 1
      assert Day1.part_one([1, -2]) == -1
      assert Day1.part_one([-1, 3]) == 2
      assert Day1.part_one([2, 1]) == 3
    end

    test "problem" do
      assert Day1.part_one(@input) == 437
    end
  end

  describe "part two" do
    test "examples" do
      changes = [1, -1]
      assert Day1.part_two(changes) == 0

      changes = [3, 3, 4, -2, -4]
      assert Day1.part_two(changes) == 10

      changes = [-6, 3, 8, 5, -6]
      assert Day1.part_two(changes) == 5

      changes = [7, 7, -2, -7, -4]
      assert Day1.part_two(changes) == 14
    end

    test "problem" do
      assert Day1.part_two(@input) == 655
    end
  end
end
