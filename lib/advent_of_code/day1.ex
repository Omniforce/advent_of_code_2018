defmodule AdventOfCode.Day1 do
  @input [:code.priv_dir(:advent_of_code), "inputs", "day1.txt"] 
    |> Path.join()
    |> File.read!()
    |> String.trim()
    |> String.split("\n")

  def part_one do
    Enum.reduce(@input, 0, &apply_operator/2)
  end

  defp apply_operator(<<"+", val::binary()>>, acc), do: acc + String.to_integer(val)
  defp apply_operator(<<"-", val::binary()>>, acc), do: acc - String.to_integer(val)

  def part_two do
    Stream.cycle(@input)
    |> Enum.reduce_while({0, MapSet.new([0])}, fn move, {current, seen} ->
      new = apply_operator(move, current)

      cond do
        MapSet.member?(seen, new) -> {:halt, new}
        true -> {:cont, {new, MapSet.put(seen, new)}}
      end
    end)
  end
end

AdventOfCode.Day1.part_one() |> IO.inspect(label: :part_one)
AdventOfCode.Day1.part_two() |> IO.inspect(label: :part_two)
