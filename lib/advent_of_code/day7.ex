defmodule AdventOfCode.Day7 do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(
         <<"Step ", dep::binary-size(1), " must be finished before step ",
           subject::binary-size(1), " can begin.">>
       ) do
    {subject, dep}
  end

  defp steps_with_deps(parsed_steps) do
    uniq_steps =
      parsed_steps
      |> Enum.flat_map(&Tuple.to_list/1)
      |> Enum.uniq()
      |> Map.new(fn i -> {i, []} end)

    Enum.reduce(parsed_steps, uniq_steps, fn {subj, dep}, acc ->
      Map.update(acc, subj, [dep], fn curr -> [dep | curr] end)
    end)
  end

  def correct_sequence(input) do
    steps_with_deps =
      parse_input(input)
      |> steps_with_deps()

    grouped =
      Enum.group_by(steps_with_deps, fn
        {_, []} -> :ready
        _ -> :pending
      end)

    [{start, _} | ready] = grouped.ready |> Enum.sort_by(&elem(&1, 0))

    all_pending_steps = grouped.pending ++ ready

    pending_deps =
      all_pending_steps
      |> Enum.flat_map(&elem(&1, 1))
      |> Enum.reject(&(&1 == start))
      |> MapSet.new()

    find_correct_sequence([start], all_pending_steps, pending_deps)
  end

  defp group_by_status(steps_with_deps, pending_steps) do
    Enum.group_by(steps_with_deps, fn {_, deps} ->
      if Enum.any?(deps, &MapSet.member?(pending_steps, &1)) do
        :pending
      else
        :ready
      end
    end)
  end

  defp find_correct_sequence(res, [], _), do: res |> List.flatten() |> Enum.join()

  defp find_correct_sequence(res, pending_steps, pending_deps) do
    grouped = group_by_status(pending_steps, pending_deps)
    [{next_step, _} | pending_ready] = find_next_step(grouped)
    updated_pending_deps = MapSet.delete(pending_deps, next_step)
    updated_pending_steps = pending_ready ++ update_pending_steps(grouped[:pending], next_step)

    find_correct_sequence(res ++ [next_step], updated_pending_steps, updated_pending_deps)
  end

  defp find_next_step(%{ready: ready}), do: Enum.sort_by(ready, &elem(&1, 0))

  defp find_next_step(%{pending: [{k, _}]}), do: k

  defp update_pending_steps([{next, _}], next), do: []
  defp update_pending_steps(nil, _), do: []
  defp update_pending_steps(pending, _), do: pending
end
