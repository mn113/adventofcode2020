defmodule Day03 do
    @tree "#"

    defp read_input do
        "../inputs/input03.txt"
        |> Path.expand
        |> File.read!
        |> String.split("\n")
    end

    @doc """
    Recursively moves across grid, counting trees
    """
    defp count_trees_in_sloped_path(grid, w, h, dx, dy, x \\ 0, y \\ 0, trees_count \\ 0) do
        char =  grid |> Enum.at(y) |> String.at(x)
        new_trees_count = trees_count + if(@tree == char, do: 1, else: 0)
        newx = x + dx - if(x + dx >= w, do: w, else: 0)
        newy = y + dy

        cond do
            newy < h -> count_trees_in_sloped_path(grid, w, h, dx, dy, newx, newy, new_trees_count)
            true  -> new_trees_count
        end
    end

    def solve do
        grid = read_input()
        width = String.length(Enum.at(grid, 0))
        height = length(grid)

        a = count_trees_in_sloped_path(grid, width, height, 1, 1)
        b = count_trees_in_sloped_path(grid, width, height, 3, 1)
        c = count_trees_in_sloped_path(grid, width, height, 5, 1)
        d = count_trees_in_sloped_path(grid, width, height, 7, 1)
        e = count_trees_in_sloped_path(grid, width, height, 1, 2)

        # part 1 = 268
        IO.puts(b)

        # part 2 = 3093068400
        IO.puts(a * b * c * d * e)
    end
end
