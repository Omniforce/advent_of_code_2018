defmodule AdventOfCode.Day6 do
  @doc ~S"""
  Parse the input into a list of tuples representing coordinates.

  ## Examples
    iex> AdventOfCode.Day6.parse_input("1, 1")
    [{1, 1}]

    iex> AdventOfCode.Day6.parse_input("1, 1\n2, 3\n4, 5\n")
    [{1, 1}, {2, 3}, {4, 5}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&line_to_coord/1)
  end

  defp line_to_coord(line) do
    String.split(line, ", ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  @doc """
  Generates a list of all potential coords within input coords.

  ## Examples
    iex> AdventOfCode.Day6.full_grid([{1, 1}, {2, 2}])
    [{1, 1}, {1, 2}, {2, 1}, {2, 2}]

    iex> AdventOfCode.Day6.full_grid([{0, 3}, {2, 2}, {3, 2}])
    [{0, 0}, {0, 1}, {0, 2}, {0, 3}, {1, 0}, {1, 1}, {1, 2}, {1, 3}, {2, 0}, {2, 1}, {2, 2}, {2, 3}, {3, 0}, {3, 1}, {3, 2}, {3, 3}]
  """
  def full_grid(coords) do
    {min, _} = Enum.min_by(coords, &elem(&1, 0))
    {_, max} = Enum.max_by(coords, &elem(&1, 1))

    for x <- min..max,
        y <- min..max,
        do: {x, y}
  end

  
  @doc ~S"""
  Part one problem

  ## Example
    iex> AdventOfCode.Day6.largest_bounded_zone("1, 1\n1, 6\n8, 3\n3, 4\n5, 5\n8, 9\n")
    17
  """
  def largest_bounded_zone(input) do
    coords = parse_input(input)

    coords
    |> full_grid()
    |> Enum.reduce(%{}, fn current, acc ->
      Map.put(acc, current, Enum.map(coords, &manhattan_distance(&1, current)))
    end)
  end

  defp manhattan_distance({x, y} = subject, {a, b}), do: {subject, abs(x - a) + abs(y - b)}
end
