defmodule AdventOfCode.Day5 do

  def react(chars) do
    chars
    |> Enum.reduce([], &do_reaction/2)
    |> Enum.reverse()
    |> List.to_string()
  end

  defp do_reaction(char, []), do: [char]
  defp do_reaction(char, [next | rest] = acc) do
    if polar_opposites?(char, next) do
      rest
    else
      [char | acc]
    end
  end

  def polar_opposites?(a, a), do: false
  def polar_opposites?(<<left::utf8>>, <<right::utf8>>) do
    abs(left - right) == 32
  end

  def improved_polymer(chars) do
    chars
    |> Enum.map(&String.downcase/1)
    |> Enum.uniq()
    |> Enum.reduce(%{}, fn remove, acc ->
      length =
        chars
        |> Enum.reject(fn char ->
          char == remove || char == String.upcase(remove)
        end)
        |> react()
        |> String.length()
      Map.put(acc, remove, length)
    end)
    |> Enum.min_by(fn {_, v} -> v end)
  end
end
