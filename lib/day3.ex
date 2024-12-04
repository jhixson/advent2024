defmodule Advent2024.Day3 do
  def read_file(path) do
    case File.read(path) do
      {:ok, memory} -> read_memory_conditional(memory)
      err -> err
    end
  end

  # Part 1 (and 2)
  defp read_memory(memory) do
    ~r{mul\((?<num1>\d+),(?<num2>\d+)\)}
    |> Regex.scan(memory, capture: :all_names)
    |> add_nums()
  end

  # Part 2
  defp read_memory_conditional(memory) do
    # first remove everything between don't and do
    # don't\(\).*?do\(\)
    # then remove everything at the end that follows don't
    # don't\(\)(.+)$
    no_dont = Regex.replace(~r{don't\(\).*?do\(\)}, memory, "")

    ~r{don't\(\)(.+)$}
    |> Regex.replace(no_dont, "")
    |> read_memory()
  end

  defp add_nums(nums) do
    Enum.reduce(nums, 0, fn [num1, num2], acc ->
      mult = String.to_integer(num1) * String.to_integer(num2)
      acc + mult
    end)
  end

end
