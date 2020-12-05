defmodule Day05 do
    @moduledoc false

    defp read_input do
        "../inputs/input05.txt"
        |> Path.expand
        |> File.read!
        |> String.split("\n")
    end

    @doc """
    Convert a string of binary search directions e.g. "FBFFBFB"
    to the integer resulting from its binary conversion
    """
    defp find_row(directions) do
        directions
        |> String.replace("F","0")
        |> String.replace("B","1")
        |> Integer.parse(2)
        |> elem(0)
    end

    @doc """
    Convert a string of binary search directions e.g. "RLR"
    to the integer resulting from its binary conversion
    """
    defp find_col(directions) do
        directions
        |> String.replace("L","0")
        |> String.replace("R","1")
        |> Integer.parse(2)
        |> elem(0)
    end

    @doc """
    From a boarding pass code e.g. "FBBFBFBLLR"
    calculate the seat number on a sequential grid
    """
    defp find_seat(code) do
        row = code |> String.slice(0,7) |> find_row
        col = code |> String.slice(7,3) |> find_col
        (row * 8) + col
    end

    def solve do
        filled_seats = read_input()
        |> Enum.map(&find_seat/1)

        # part 1 - 989
        lo = Enum.min(filled_seats)
        hi = Enum.max(filled_seats)
        IO.puts hi

        # part 2 - 548
        lo..hi
        |> Enum.filter(fn i -> i not in filled_seats end)
        |> Enum.at(0)
        |> IO.puts
    end
end
