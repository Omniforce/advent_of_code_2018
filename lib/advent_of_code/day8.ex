defmodule AdventOfCode.Day8 do
  def parse_input(input) do
    input
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def metadata_sum([]), do: 0

  def metadata_sum([child_count, meta_count | input]) do
    {children_sum, rest} = get_children(child_count, meta_count, input)
    children_sum + metadata_sum(rest)
  end

  defp get_children(0, meta_count, input) do
    {meta, rest} = Enum.split(input, meta_count)
    {Enum.sum(meta), rest}
  end

  defp get_children(child_count, meta_count, [next_child, next_meta | input])
       when child_count > 0 do
    {next_children_sum, next_rest} = get_children(next_child, next_meta, input)
    {children_sum, rest} = get_children(child_count - 1, meta_count, next_rest)
    {next_children_sum + children_sum, rest}
  end
end
