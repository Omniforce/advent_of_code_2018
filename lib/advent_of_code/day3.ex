defmodule AdventOfCode.Day3 do
  def overclaimed_inches(input) do
    Enum.reduce(input, %{}, fn claim, claimed ->
      claim
      |> parse_claim()
      |> claim_to_coords()
      |> count_coords(claimed)
    end)
    |> Enum.count(fn {_, v} -> v >= 2 end)
  end

  defp count_coords(coords, claimed) do
    Enum.reduce(coords, claimed, fn coord, claimed ->
      Map.update(claimed, coord, 1, &(&1 + 1))
    end)
  end

  def parse_claim(claim) do
    [id, left, top, w, h] =
      claim
      |> String.split(["#", " @ ", ",", ": ", "x"], trim: true)
      |> Enum.map(&String.to_integer/1)

    %{id: id, margin_left: left, margin_top: top, width: w, height: h}
  end

  def claim_to_coords(%{margin_left: left, margin_top: top, width: w, height: h}) do
    for x <- left..(left + w - 1),
        y <- top..(top + h - 1),
        do: {x, y}
  end

  def non_overlapping_claim(input) do
    claims =
      Enum.map(input, fn claim ->
        claim = parse_claim(claim)
        coords = claim_to_coords(claim)
        {claim.id, MapSet.new(coords)}
      end)

    Enum.reduce_while(claims, false, fn {subject_id, subject_coords}, _ ->
      Enum.reduce_while(claims, false, fn {test_id, test_coords}, acc ->
        cond do
          subject_id == test_id && acc == subject_id ->
            {:cont, subject_id}

          subject_id == test_id ->
            {:cont, false}

          true ->
            case MapSet.disjoint?(subject_coords, test_coords) do
              true -> {:cont, subject_id}
              _ -> {:halt, false}
            end
        end
      end)
      |> case do
        false -> {:cont, false}
        found -> {:halt, found}
      end
    end)
  end
end
