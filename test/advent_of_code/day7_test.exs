defmodule AdventOfCode.Day7Test do
  use ExUnit.Case, asycn: true
  alias AdventOfCode.Day7

  @input [:code.priv_dir(:advent_of_code), "inputs", "day7.txt"]
         |> Path.join()
         |> File.read!()


  describe "part one" do

    test "parse_input/1" do
      input =
        """
        Step C must be finished before step A can begin.
        Step C must be finished before step F can begin.
        Step A must be finished before step B can begin.
        """

      assert [
        {"A", "C"},
        {"F", "C"},
        {"B", "A"}
      ] = Day7.parse_input(input)
    end

    test "example" do
      input =
        """
        Step C must be finished before step A can begin.
        Step C must be finished before step F can begin.
        Step A must be finished before step B can begin.
        Step A must be finished before step D can begin.
        Step B must be finished before step E can begin.
        Step D must be finished before step E can begin.
        Step F must be finished before step E can begin.
        """

      assert "CABDFE" == Day7.correct_sequence(input)
    end

    test "problem" do
      assert "OKBNLPHCSVWAIRDGUZEFMXYTJQ" == Day7.correct_sequence(@input)
    end
  end
end
