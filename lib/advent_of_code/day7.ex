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

  defp find_correct_sequence(res, [], _), do: res |> List.flatten() |> Enum.join()

  defp find_correct_sequence(res, pending_steps, pending_deps) do
    grouped = group_by_status(pending_steps, pending_deps)
    [{next_step, _} | pending_ready] = find_next_step(grouped)
    updated_pending_deps = MapSet.delete(pending_deps, next_step)
    updated_pending_steps = pending_ready ++ update_pending_steps(grouped[:pending], next_step)

    find_correct_sequence(res ++ [next_step], updated_pending_steps, updated_pending_deps)
  end

  def total_time(input, min_time_per_step \\ 60, num_workers \\ 5) do
    steps_with_deps =
      parse_input(input)
      |> steps_with_deps()

    grouped_steps =
      Enum.group_by(steps_with_deps, fn
        {_, []} -> :ready
        _ -> :pending
      end)

    {start, ready} = grouped_steps.ready |> Enum.sort_by(&elem(&1, 0)) |> Enum.split(num_workers)
    starting_steps = Enum.map(start, &elem(&1, 0))

    pending_deps =
      grouped_steps.pending
      |> Enum.flat_map(&elem(&1, 1))
      |> MapSet.new()

    acc = %{
      time: 0,
      ready: ready,
      num_workers: num_workers,
      min_time_per_step: min_time_per_step,
      in_progress: Map.new(starting_steps, &start_step(&1, min_time_per_step))
    }

    do_step(acc, grouped_steps.pending, pending_deps)
  end

  defp start_step(step, min_time_per_step),
    do: {step, {0, step_to_seconds(step, min_time_per_step)}}

  defp do_step(%{time: t, in_progress: in_progress, ready: []}, _, _)
       when map_size(in_progress) == 0,
       do: t

  defp do_step(acc, pending_steps, pending_deps) do
    {completed, in_progress} = advance_one_second(acc.in_progress)
    in_progress_count = Map.size(in_progress)
    updated_pending_deps = Enum.reduce(completed, pending_deps, &MapSet.delete(&2, elem(&1, 0)))

    grouped = group_by_status(pending_steps, updated_pending_deps)

    all_ready =
      (grouped[:ready] || [] ++ acc.ready)
      |> Enum.uniq()
      |> Enum.reject(fn {step, _} -> Map.has_key?(in_progress, step) end)

    {up_next, ready} = Enum.split(all_ready, acc.num_workers - in_progress_count)

    updated_in_progress =
      Enum.reduce(up_next, in_progress, fn i, in_prog ->
        {step, counts} = start_step(elem(i, 0), acc.min_time_per_step)
        Map.put(in_prog, step, counts)
      end)

    updated_acc = %{acc | ready: ready, in_progress: updated_in_progress, time: acc.time + 1}

    case completed do
      [] ->
        do_step(updated_acc, grouped[:pending] || [], updated_pending_deps)

      _ ->
        %{updated_acc | ready: updated_acc.ready ++ (grouped[:ready] || [])}
        |> do_step(grouped[:pending] || [], updated_pending_deps)
    end
  end

  defp advance_one_second(in_progress) do
    Enum.reduce(in_progress, {[], %{}}, fn i, {completed, still_going} ->
      case i do
        {_, {current, limit}} = step when current + 1 == limit ->
          {[step | completed], still_going}

        {step, {current, limit}} ->
          {completed, Map.put(still_going, step, {current + 1, limit})}
      end
    end)
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

  defp find_next_step(%{ready: ready}), do: Enum.sort_by(ready, &elem(&1, 0))
  defp find_next_step(%{pending: [{k, _}]}), do: k

  defp update_pending_steps([{next, _}], next), do: []
  defp update_pending_steps(nil, _), do: []
  defp update_pending_steps(pending, _), do: pending

  def step_to_seconds(<<step::utf8>>, min_time_per_step), do: step - 64 + min_time_per_step
end
