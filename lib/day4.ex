defmodule Advent2024.Day4 do
  def read_file(path) do
    case File.open(path, [:read]) do
      {:ok, device} -> read_puzzle(device, 0, %{})
      err -> err
    end
  end

  defp read_puzzle(device, row, puzzle_coords) do
    case IO.read(device, :line) do
      :eof ->
        puzzle_coords
        |> find_x()
        |> find_words(puzzle_coords)

      line ->
        coords = build_coords(line, row)
        read_puzzle(device, row + 1, Map.merge(puzzle_coords, coords))
    end
  end

  defp build_coords(line, row) do
    line
    |> String.replace("\n", "")
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {letter, num} -> {{row, num}, letter} end)
    |> Map.new()
  end

  defp find_x(puzzle) do
    puzzle
    |> Enum.filter(fn {_k, letter} -> letter == "X" end)
  end

  defp find_words(x_marks, puzzle) do
    moves = [
      {1, 0},
      {1, 1},
      {0, 1},
      {-1, 1},
      {-1, 0},
      {-1, -1},
      {0, -1},
      {1, -1}
    ]

    Enum.map(x_marks, fn point ->
      {{x, y}, "X"} = point

      # IO.inspect("checking #{x}, #{y}")

      Enum.reduce(moves, [], fn move, acc ->
        [check_move(puzzle, {x, y}, move, ~w(M A S)) | acc]
      end)
    end)
    |> List.flatten()
    |> Enum.count(& &1 == true)
  end

  def check_move(_puzzle, _start, _move, []), do: true

  def check_move(puzzle, {start_x, start_y}, {move_x, move_y}, [letter | rest]) do
    point = {start_x + move_x, start_y + move_y}
    # IO.inspect("MOVING FROM #{start_x}, #{start_y} to #{inspect(point)}")

    case Map.get(puzzle, point) do
      ^letter ->
        # IO.inspect("FOUND #{letter} at #{inspect(point)}")
        check_move(puzzle, point, {move_x, move_y}, rest)

      _bad ->
        # IO.inspect(bad, label: "NO GOOD")
        false
    end
  end
end
