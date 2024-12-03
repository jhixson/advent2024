defmodule Advent2024.Day2 do
  def read_file(path) do
    case File.open(path, [:read]) do
      {:ok, device} -> read_reports(device, 0)
      err -> err
    end
  end

  defp read_reports(device, safe_count) do
    case IO.read(device, :line) do
      :eof ->
        safe_count

      line ->
        case check_safety(line) do
          true -> read_reports(device, safe_count + 1)
          _ -> read_reports(device, safe_count)
        end
    end
  end

  defp check_safety(line) do
    line
    |> String.split(~r{\s}, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> is_safe_with_dampener()
  end

  # Part 1
  defp is_safe(line) when is_list(line) do
    up_and_down(line) and increase_or_decrease(line)
  end

  # Part 2
  defp is_safe_with_dampener(line) when is_list(line) do
    up_down_with_problems = up_and_down_with_dampener(line, 0, [])

    ok_with_problems = increase_or_decrease_with_dampener(line, 0, [])

    [up_down_with_problems, ok_with_problems]
    |> Enum.zip_with(fn [up_down, ok] -> up_down and ok end)
    |> Enum.any?()
  end

  # Part 1
  defp up_and_down(line) do
    asc_sort = Enum.sort(line)
    asc_sort == line or Enum.reverse(asc_sort) == line
  end

  # Part 1
  defp increase_or_decrease(line) do
    {_res, safe} =
      line
      |> Enum.reduce_while({0, :init}, fn next, {current, safe} ->
        if safe == :init or (abs(current - next) > 0 and abs(current - next) < 4) do
          {:cont, {next, true}}
        else
          {:halt, {next, false}}
        end
      end)

    safe
  end

  # Part 2
  def up_and_down_with_dampener(line, index, results) when index == length(line),
    do: results

  def up_and_down_with_dampener(line, index, results) do
    sublist_safe =
      line
      |> List.delete_at(index)
      |> up_and_down()

    up_and_down_with_dampener(line, index + 1, [sublist_safe | results])
  end

  # Part 2
  def increase_or_decrease_with_dampener(line, index, results) when index == length(line),
    do: results

  def increase_or_decrease_with_dampener(line, index, results) do
    sublist_safe =
      line
      |> List.delete_at(index)
      |> increase_or_decrease()

    increase_or_decrease_with_dampener(line, index + 1, [sublist_safe | results])
  end
end
