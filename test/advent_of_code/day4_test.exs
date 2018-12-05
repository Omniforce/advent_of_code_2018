defmodule AdventOfCode.Day4Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day4

  @input [:code.priv_dir(:advent_of_code), "inputs", "day4.txt"]
         |> Path.join()
         |> File.read!()
         |> String.split("\n", trim: true)

  describe "part one" do
    test "parse_entry/1" do
      assert {{:begin, 10}, [1518, 11, 1, 0, 0]} = 
        Day4.parse_entry("[1518-11-01 00:00] Guard #10 begins shift")

      assert {:sleep, [1518, 11, 1, 0, 5]} = 
        Day4.parse_entry("[1518-11-01 00:05] falls asleep")

      assert {:wake, [1518, 11, 1, 0, 25]} = 
        Day4.parse_entry("[1518-11-01 00:25] wakes up")
    end

    test "most_minutes_slept/1" do
      input =
        """
        [1518-11-05 00:03] Guard #99 begins shift
        [1518-11-05 00:45] falls asleep
        [1518-11-05 00:55] wakes up
        """
        |> String.split("\n", trim: true)

      assert {99, %{total: 10}} = Day4.most_minutes_slept(input)

      input =
        """
        [1518-11-05 00:03] Guard #99 begins shift
        [1518-11-05 00:45] falls asleep
        [1518-11-05 00:55] wakes up
        [1618-11-06 00:03] Guard #99 begins shift
        [1618-11-06 00:26] falls asleep
        [1618-11-06 00:36] wakes up
        """
        |> String.split("\n", trim: true)

      assert {99, %{total: 20}} = Day4.most_minutes_slept(input)

      input =
        """
        [1518-11-05 00:03] Guard #19 begins shift
        [1518-11-05 00:45] falls asleep
        [1518-11-05 00:55] wakes up
        [1618-11-06 00:03] Guard #99 begins shift
        [1618-11-06 00:26] falls asleep
        [1618-11-06 00:37] wakes up
        """
        |> String.split("\n", trim: true)

      assert {99, %{total: 11}} = Day4.most_minutes_slept(input)
    end

    test "most_common_minutes/1" do
      input = [1..11, 11..20]

      # {minute, count}
      assert {11, 2} = Day4.most_common_minute(input)
    end

    test "example" do
      input =
        """
        [1518-11-01 00:00] Guard #10 begins shift
        [1518-11-01 00:05] falls asleep
        [1518-11-01 00:25] wakes up
        [1518-11-01 00:30] falls asleep
        [1518-11-01 00:55] wakes up
        [1518-11-01 23:58] Guard #99 begins shift
        [1518-11-02 00:40] falls asleep
        [1518-11-02 00:50] wakes up
        [1518-11-03 00:05] Guard #10 begins shift
        [1518-11-03 00:24] falls asleep
        [1518-11-03 00:29] wakes up
        [1518-11-04 00:02] Guard #99 begins shift
        [1518-11-04 00:36] falls asleep
        [1518-11-04 00:46] wakes up
        [1518-11-05 00:03] Guard #99 begins shift
        [1518-11-05 00:45] falls asleep
        [1518-11-05 00:55] wakes up
        """
        |> String.split("\n", trim: true)

      assert 240 = Day4.part_one(input)
    end

    test "example shuffled" do
      input =
        """
        [1518-11-01 00:00] Guard #10 begins shift
        [1518-11-01 00:05] falls asleep
        [1518-11-01 00:25] wakes up
        [1518-11-01 00:30] falls asleep
        [1518-11-01 00:55] wakes up
        [1518-11-01 23:58] Guard #99 begins shift
        [1518-11-02 00:40] falls asleep
        [1518-11-02 00:50] wakes up
        [1518-11-03 00:05] Guard #10 begins shift
        [1518-11-03 00:24] falls asleep
        [1518-11-03 00:29] wakes up
        [1518-11-04 00:02] Guard #99 begins shift
        [1518-11-04 00:36] falls asleep
        [1518-11-04 00:46] wakes up
        [1518-11-05 00:03] Guard #99 begins shift
        [1518-11-05 00:45] falls asleep
        [1518-11-05 00:55] wakes up
        """
        |> String.split("\n", trim: true)
        |> Enum.shuffle()

      assert 240 = Day4.part_one(input)
    end

    test "problem" do
      assert 77941 = Day4.part_one(@input)
    end
  end

  describe "part two" do
    test "example" do
      input =
        """
        [1518-11-01 00:00] Guard #10 begins shift
        [1518-11-01 00:05] falls asleep
        [1518-11-01 00:25] wakes up
        [1518-11-01 00:30] falls asleep
        [1518-11-01 00:55] wakes up
        [1518-11-01 23:58] Guard #99 begins shift
        [1518-11-02 00:40] falls asleep
        [1518-11-02 00:50] wakes up
        [1518-11-03 00:05] Guard #10 begins shift
        [1518-11-03 00:24] falls asleep
        [1518-11-03 00:29] wakes up
        [1518-11-04 00:02] Guard #99 begins shift
        [1518-11-04 00:36] falls asleep
        [1518-11-04 00:46] wakes up
        [1518-11-05 00:03] Guard #99 begins shift
        [1518-11-05 00:45] falls asleep
        [1518-11-05 00:55] wakes up
        """
        |> String.split("\n", trim: true)

      assert 4455 = Day4.part_two(input)
    end

    test "problem" do
      assert 35289 = Day4.part_two(@input)
    end
  end
end
