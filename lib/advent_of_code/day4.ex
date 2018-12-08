defmodule AdventOfCode.Day4 do
  def part_one(input) do
    {id, %{sleeps: sleeps}} = most_minutes_slept(input)
    {min, _} = most_common_minute(sleeps)
    id * min
  end

  def part_two(input) do
    {guard, {min, _}} =
      input
      |> parse_input()
      |> record_sleep_per_guard()
      |> Enum.map(fn {guard, %{sleeps: sleeps}} ->
        {guard, most_common_minute(sleeps)}
      end)
      |> Enum.max_by(fn {_guard, {_min, count}} -> count end)

    guard * min
  end

  def most_minutes_slept(input) do
    input
    |> parse_input()
    |> record_sleep_per_guard()
    |> Enum.max_by(fn {_, %{total: total}} -> total end)
  end

  defp record_sleep_per_guard(entries) do
    entries
    |> Enum.reduce({nil, %{}}, fn {action, [_, _, _, _, min]}, {current_guard, acc} ->
      case {current_guard, action} do
        {_, {:begin, id}} ->
          {id, acc}

        {id, :sleep} ->
          {{:start, id, min}, acc}

        {{:start, id, start_min}, :wake} ->
          total = min - start_min

          update =
            Map.update(
              acc,
              id,
              %{total: total, sleeps: [start_min..(min - 1)]},
              &update_acc(&1, start_min, min, total)
            )

          {id, update}
      end
    end)
    |> elem(1)
  end

  defp update_acc(%{total: cur_total, sleeps: sleeps}, start_sleep, end_sleep, total) do
    %{total: cur_total + total, sleeps: [start_sleep..end_sleep | sleeps]}
  end

  def most_common_minute(sleeps) do
    sleeps
    |> Enum.reduce(%{}, fn range, minute_counts ->
      Enum.to_list(range)
      |> Enum.reduce(minute_counts, fn i, acc -> Map.update(acc, i, 1, &(&1 + 1)) end)
    end)
    |> Enum.sort()
    |> Enum.max_by(&elem(&1, 1))
  end

  defp parse_input(input) do
    input
    |> Enum.map(&parse_entry/1)
    |> Enum.sort_by(fn {_, [_, m, d, h, mi]} -> {m, d, h, mi} end)
  end

  def parse_entry(
        <<"[", y::binary-size(4), "-", m::binary-size(2), "-", d::binary-size(2), " ",
          h::binary-size(2), ":", min::binary-size(2), "] ", rest::binary>>
      ) do
    datetime = [y, m, d, h, min] |> Enum.map(&String.to_integer/1)
    {action(rest), datetime}
  end

  defp action("falls asleep"), do: :sleep
  defp action("wakes up"), do: :wake

  defp action(<<"Guard #", rest::binary>>) do
    {id, _} = Integer.parse(rest)
    {:begin, id}
  end
end
