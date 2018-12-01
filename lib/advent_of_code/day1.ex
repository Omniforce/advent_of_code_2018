defmodule AdventOfCode.Day1 do
  def part_one(input) do
    Enum.sum(input)
  end

  def part_two(input) do
    Stream.cycle(input)
    |> Enum.reduce_while({0, MapSet.new([0])}, fn move, {current, seen} ->
      new = move + current

      cond do
        MapSet.member?(seen, new) -> {:halt, new}
        true -> {:cont, {new, MapSet.put(seen, new)}}
      end
    end)
  end
end
