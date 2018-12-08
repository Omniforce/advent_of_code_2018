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
  """
  def full_grid(min_x, max_x, min_y, max_y) do
    for x <- min_x..max_x,
        y <- min_y..max_y,
        do: {x, y}
  end

  @doc ~S"""
  Part one problem

  # conflicts - 11
  # A - 1, 1 - 14
  # B - 1, 6 - 13
  # C - 8, 3 - 20
  # D - 3, 4 - 8
  # E - 5, 5 - 16 
  # F - 8, 9 - 12

  ## Example
    iex> AdventOfCode.Day6.largest_bounded_zone("1, 1\n1, 6\n8, 3\n3, 4\n5, 5\n8, 9\n")
    17
  """
  def largest_bounded_zone(input) do
    coords = parse_input(input)
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coords, &elem(&1, 0))
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coords, &elem(&1, 1))

    full_grid(min_x, max_x, min_y, max_y)
    |> calculate_distance_from_each_coord(coords)
    |> Enum.map(&find_closest/1)
    |> Enum.group_by(fn {_coord, closest} -> closest end, fn {coord, _} -> coord end)
    |> Enum.filter(&finite?(&1, min_x, max_x, min_y, max_y))
    |> Enum.map(fn {_, coords} -> Enum.count(coords) end)
    |> Enum.max()
  end

  @doc """
  ## Example
     iex> AdventOfCode.Day6.manhattan_distance({0, 0}, {1, 1})
     {{0, 0}, 2}

     iex> AdventOfCode.Day6.manhattan_distance({1, 1}, {5, 3})
     {{1, 1}, 6}
  """
  def manhattan_distance({a, b} = subject, {c, d}), do: {subject, abs(a - c) + abs(b - d)}

  defp calculate_distance_from_each_coord(full_grid, coords) do
    Enum.reduce(full_grid, %{}, fn current, acc ->
      Map.put(acc, current, Enum.map(coords, &manhattan_distance(&1, current)))
    end)
  end

  defp find_closest({coord, distances}) do
    {closest, distance} = Enum.min_by(distances, fn {_, distance} -> distance end)

    if Enum.count(distances, fn {_, d} -> d == distance end) > 1 do
      {coord, nil}
    else
      {coord, closest}
    end
  end

  defp finite?({_, nil}, _, _, _, _), do: false

  defp finite?({_, coords}, min_x, max_x, min_y, max_y) do
    Enum.all?(coords, fn {x, y} ->
      x > min_x && x < max_x && y > min_y and y < max_y
    end)
  end
end
