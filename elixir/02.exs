defmodule Day02 do
    @moduledoc false

    defp read_input do
        "../inputs/input02.txt"
        |> Path.expand
        |> File.read!
        |> String.split("\n")
    end

    @doc """
    @param {String} - line
    @returns {Map}
    """
    defp regex_parse_line(line) do
        captures = Regex.named_captures(
            ~r/(?<lo>\d+)-(?<hi>\d+) (?<letter>[a-z]+): (?<password>[a-z]+)/,
            String.trim(line)
        )
        %{
            :hi => captures["hi"] |> String.to_integer,
            :lo => captures["lo"] |> String.to_integer,
            :letter => captures["letter"],
            :password => captures["password"]
        }
    end

    @doc """
    Valid if letter appears in password between lo and hi times
    @param {Map} - params
    @returns {Boolean}
    """
    defp is_valid_part1(params) do
        %{:password => password, :letter => letter, :lo => lo, :hi => hi} = params

        count = password
        |> String.graphemes
        |> Enum.count(fn c -> c == letter end)

        count >= lo && count <= hi
    end

    @doc """
    Valid if lo'th XOR hi'th index of password is letter
    @param {Map} - params
    @returns {Boolean}
    """
    defp is_valid_part2(params) do
        %{:password => password, :letter => letter, :lo => lo, :hi => hi} = params


        first = letter == String.at(password, lo-1)
        second = letter ==  String.at(password, hi-1)
        # xor
        (first or second) and not (first and second)
    end

    def solve do
        input = read_input()
        |> Enum.map(&regex_parse_line/1)

        # part 1
        input
        |> Enum.filter(&is_valid_part1/1)
        |> Enum.count
        |> IO.puts

        # part 2
        input
        |> Enum.filter(&is_valid_part2/1)
        |> Enum.count
        |> IO.puts
    end
end
