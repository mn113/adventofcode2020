defmodule Day10 do
    @moduledoc false

    defp read_input do
        "../inputs/input10.txt"
        |> Path.expand
        |> File.read!
        |> String.split("\n")
        |> Enum.map(&String.to_integer/1)
        |> Enum.sort
    end

    def get_adaptors do
        input = read_input()
        goal = List.last(input) + 3
        [0] ++ input ++ [goal]
    end

    defp get_jumps(adaptors, wanted_steps) do
        jumps = adaptors
        |> Enum.with_index
        |> Enum.map(fn tup ->
            {curr_val, i} = tup
            if i+1 < length(adaptors) do
                next_val = adaptors |> Enum.at(i+1)
                jumpsize = next_val - curr_val
                {i, jumpsize}
            else
                {i, nil}
            end
        end)

        wanted_steps
        |> Enum.map(fn step ->
            jumps
            |> Enum.filter(fn j -> elem(j,1) == step end)
            |> Enum.map(fn j -> elem(j,0) end)
        end)
    end

    def solve do
        adaptors = get_adaptors()
        # adaptors = [1,4,5,6,7,10,11,12,15,16,19]

        [single_jumps, triple_jumps] = get_jumps(adaptors, [1,3])
        |> IO.inspect

        # part 1
        IO.puts(length(single_jumps) * length(triple_jumps))
    end
end
