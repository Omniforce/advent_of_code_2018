defmodule AdventOfCode.Day5Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Day5

  @input [:code.priv_dir(:advent_of_code), "inputs", "day5.txt"]
         |> Path.join()
         |> File.read!()
         |> String.trim()
         |> String.split("", trim: true)

  describe "part one" do
    test "react/1" do
      input = "dabAcCaCBAcCcaDA" |> String.split("", trim: true)
      assert "dabCBAcaDA" = Day5.react(input)
    end

    test "polar_opposites?/2" do
      assert Day5.polar_opposites?("a", "A")
      assert Day5.polar_opposites?("Z", "z")
      assert Day5.polar_opposites?("n", "N")
      refute Day5.polar_opposites?("a", "B")
      refute Day5.polar_opposites?("a", "a")
      refute Day5.polar_opposites?("U", "U")
    end

    test "problem" do
      assert 10878 == Day5.react(@input) |> String.length()
    end
  end

  describe "part two" do
    test "improved_polymer/1" do
      input = "dabAcCaCBAcCcaDA" |> String.split("", trim: true)
      assert {"c", 4} = Day5.improved_polymer(input)
    end

    test "problem" do
      assert {"f", 6874} == Day5.improved_polymer(@input)
    end
  end
end
