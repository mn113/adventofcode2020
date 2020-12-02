defmodule Day01 do
    @year 2020

    defp read_input do
        File.read!(Path.expand("../inputs/input01.txt"))
        |> String.split("\n")
        |> Enum.map(fn line -> line |> Integer.parse end)
        |> Enum.map(fn {num, _} -> num end)
        |> Enum.sort
        |> Enum.take_while(fn num -> num < @year end)
    end

    def part1 do
        input = read_input()
        limit = length(input) -1
        for i <- 0..limit-1 do
            for j <- i+1..limit do
                sum = Enum.at(input, i) + Enum.at(input, j)
                if sum == @year do
                    IO.puts Enum.at(input, i) * Enum.at(input, j)
                end
            end
        end
    end

    def part2 do
        input = read_input()
        limit = length(input) -1
        for i <- 0..limit-2 do
            for j <- i+1..limit-1 do
                for k <- j+1..limit do
                    sum = Enum.at(input, i) + Enum.at(input, j) + Enum.at(input, k)
                    if sum == @year do
                        IO.puts Enum.at(input, i) * Enum.at(input, j) * Enum.at(input, k)
                    end
                end
            end
        end
    end
end

# P1: 1005459
# P2: 92643264