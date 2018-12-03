defmodule AdventOfCode.Day2Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Day2

  @input [:code.priv_dir(:advent_of_code), "inputs", "day2.txt"]
         |> Path.join()
         |> File.read!()
         |> String.split("\n", trim: true)

  describe "part one - checksum" do
    test "example" do
      input = [
        "abcdef",
        "bababc",
        "abbcde",
        "abcccd",
        "aabcdd",
        "abcdee",
        "ababab"
      ]

      assert Day2.checksum(input) == 12
    end

    test "problem" do
      assert Day2.checksum(@input) == 6225
    end
  end

  describe "part two" do
    test "example" do
      input =
        """
        abcde
        fghij
        klmno
        pqrst
        fguij
        axcye
        wvxyz
        """
        |> String.split("\n")

      assert Day2.common_letters(input) == "fgij"
    end

    test "problem" do
      assert Day2.common_letters(@input) == "revtaubfniyhsgxdoajwkqilp"
    end
  end
end
