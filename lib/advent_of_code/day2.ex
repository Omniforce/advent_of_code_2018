defmodule AdventOfCode.Day2 do

  @doc "Part one"
  def checksum(input) do
    {double_count, triple_count} =
      Enum.reduce(input, {0, 0}, fn label, {double_count, triple_count} ->
        counts = char_count(label)
        doubles = if Enum.any?(counts, fn {_, v} -> v == 2 end), do: 1, else: 0
        triples = if Enum.any?(counts, fn {_, v} -> v == 3 end), do: 1, else: 0

        {double_count + doubles, triple_count + triples}
      end)

    double_count * triple_count
  end

  defp char_count(string) do
    string
    |> String.codepoints()
    |> Enum.reduce(%{}, fn char, acc -> 
      Map.update(acc, char, 1, & &1 + 1)
    end)
  end

  @doc "Part two"
  def common_letters(input) do
    Enum.reduce_while(input, MapSet.new([]), fn label, seen ->
      permutations = label_permutations(label)

      Enum.reduce_while(permutations, nil, fn permutation, _ ->
        if MapSet.member?(seen, permutation) do
          {:halt, permutation}
        else
          {:cont, nil}
        end
      end)
      |> case do
        nil -> {:cont, update_seen(seen, permutations)} 
        found -> {:halt, found}
      end
    end)
  end

  defp label_permutations(label) do
    chars = String.codepoints(label)
    length = Enum.count(chars)

    for i <- 0..length-1 do
      {start, [_ | rest]} = Enum.split(chars, i) 
      Enum.join(start ++ rest, "")
    end
  end

  defp update_seen(mapset, new) do
    Enum.reduce(new, mapset, fn i, acc ->
      MapSet.put(acc, i)
    end)
  end
end
