defmodule Advent2024.Day1 do
  def read_file(path) do
    case File.open(path, [:read]) do
      {:ok, file} -> parse_file([[], []], file)
      err -> err
    end
  end

  defp parse_file(lines, file) do
    case IO.read(file, :line) do
      :eof ->
        lines
        # |> sort_lists()
        |> similarity()

      data ->
        [a, b] = get_lines(data) |> Enum.map(&String.to_integer/1)
        [list1, list2] = lines

        [[a | list1], [b | list2]]
        |> parse_file(file)
    end
  end

  defp get_lines(data_str) do
    Regex.split(~r{\s+}, data_str, trim: true)
  end

  # Part 1
  defp sort_lists([list1, list2]) do
    sorted1 = Enum.sort(list1)
    sorted2 = Enum.sort(list2)

    sorted1
    |> Enum.zip(sorted2)
    |> Enum.map(fn {num1, num2} -> abs(num1 - num2) end)
    |> Enum.sum()
  end

  # Part 2
  defp similarity([list1, list2]) do
    counts = for num <- list2, num in list1, reduce: %{} do
      acc -> Map.update(acc, num, 1, &(&1 + 1))
    end

    Enum.reduce(list1, 0, fn num, acc ->
      count = Map.get(counts, num, 0)
      acc + (num * count)
    end)
  end
end
