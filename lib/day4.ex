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
        # Part 1
        # puzzle_coords
        # |> find_starting_letter("X")
        # |> find_words(puzzle_coords)

        # Part 2
        puzzle_coords
        |> find_starting_letter("A")
        |> find_crosses(puzzle_coords)

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

  defp find_starting_letter(puzzle, starting_letter) do
    puzzle
    |> Enum.filter(fn {_k, letter} -> letter == starting_letter end)
  end

  # Part 1
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

      Enum.reduce(moves, [], fn move, acc ->
        [check_move(puzzle, {x, y}, move, ~w(M A S)) | acc]
      end)
    end)
    |> List.flatten()
    |> Enum.count(&(&1 == true))
  end

  # Part 2
  defp find_crosses(a_marks, puzzle) do
    Enum.map(a_marks, fn {{x, y}, "A"} = _point ->
      north_west = Map.get(puzzle, {x - 1, y - 1})
      north_east = Map.get(puzzle, {x + 1, y - 1})
      south_west = Map.get(puzzle, {x - 1, y + 1})
      south_east = Map.get(puzzle, {x + 1, y + 1})

      (north_east == "M" and north_west == "M" and south_east == "S" and south_west == "S") or
        (north_east == "S" and north_west == "S" and south_east == "M" and south_west == "M") or
        (north_east == "S" and north_west == "M" and south_east == "S" and south_west == "M") or
        (north_east == "M" and north_west == "S" and south_east == "M" and south_west == "S")
    end)
    |> List.flatten()
    |> Enum.count(&(&1 == true))
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
