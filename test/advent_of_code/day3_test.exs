defmodule AdventOfCode.Day3Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day3

  @input [:code.priv_dir(:advent_of_code), "inputs", "day3.txt"]
         |> Path.join()
         |> File.read!()
         |> String.split("\n", trim: true)

  describe "part one" do
    test "example" do
      input =
        """
        #1 @ 1,3: 4x4
        #2 @ 3,1: 4x4
        #3 @ 5,5: 2x2
        """
        |> String.split("\n", trim: true)

      assert Day3.overclaimed_inches(input) == 4
    end

    test "parse_claim/1" do
      input = "#123 @ 3,2: 5x4"

      assert %{id: 123, margin_left: 3, margin_top: 2, width: 5, height: 4} =
               Day3.parse_claim(input)
    end

    test "claim_to_coords/1" do
      input = %{margin_left: 0, margin_top: 0, width: 1, height: 1}
      assert Day3.claim_to_coords(input) == [{0, 0}]

      input = %{margin_left: 0, margin_top: 0, width: 2, height: 2}
      assert Day3.claim_to_coords(input) == [{0, 0}, {0, 1}, {1, 0}, {1, 1}]

      input = %{margin_left: 3, margin_top: 3, width: 2, height: 2}
      assert Day3.claim_to_coords(input) == [{3, 3}, {3, 4}, {4, 3}, {4, 4}]
    end

    test "problem" do
      assert Day3.overclaimed_inches(@input) == 100_261
    end
  end

  describe "part two" do
    test "example" do
      input =
        """
        #1 @ 1,3: 4x4
        #2 @ 3,1: 4x4
        #3 @ 5,5: 2x2
        """
        |> String.split("\n", trim: true)

      assert Day3.non_overlapping_claim(input) == 3
    end

    test "problem" do
      assert Day3.non_overlapping_claim(@input) == 251
    end
  end
end
