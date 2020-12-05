defmodule Day04 do
    @moduledoc false

    defp read_input do
        "../inputs/input04.txt"
        |> Path.expand
        |> File.read!
        |> String.split("\n\n", trim: true)
        |> Enum.map(fn record ->
            record
            |> String.split(~r/\s/, trim: true)
            |> Enum.map(fn field ->
                field
                |> String.split(":")
            end)
        end)
    end

    @doc """
    Validate presence of required keys
    """
    def required_fields_present?(record) do
        required = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        required
        |> Enum.all?(fn key ->
            record |> Enum.any?(fn pair ->
                Enum.at(pair, 0) == key
            end)
        end)
    end

    @doc """
    Validate year format
    """
    def valid_year?(val, min, max), do: val >= min && val <= max

    @doc """
    Validate hair colour format
    """
    def valid_hair_colour?(val), do: Regex.match?(~r/^#[0-9a-f]{6}$/, val)

    @doc """
    Validate height format
    """
    def valid_height?(val) do
        num = val |> String.replace(~r/(cm|in)?$/, "") |> String.to_integer
        unit = val |> String.replace(~r/^[0-9]+/, "")
        case unit do
            "cm" -> 150 <= num && num <= 193
            "in" -> 59 <= num && num <= 76
            ____ -> false
        end
    end

    @doc """
    Validate eye colour format
    """
    def valid_eye_colour?(val), do: val in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

    @doc """
    Validate pid format
    """
    def valid_pid?(val), do: Regex.match?(~r/^[0-9]{9}$/, val)

    @doc """
    Validate all aspects of a record
    """
    def fully_valid?(record) do
        cond do
            !required_fields_present?(record) ->
                false
            true ->
                record
                |> Enum.all?(fn field ->
                    [key, val] = field
                    case key do
                        "byr" -> valid_year?(String.to_integer(val), 1920, 2002)
                        "iyr" -> valid_year?(String.to_integer(val), 2010, 2020)
                        "eyr" -> valid_year?(String.to_integer(val), 2020, 2030)
                        "hcl" -> valid_hair_colour?(val)
                        "hgt" -> valid_height?(val)
                        "ecl" -> valid_eye_colour?(val)
                        "pid" -> valid_pid?(val)
                        _____ -> true
                    end
                end)
        end
    end

    def solve do
        # part 1 - 247
        read_input()
        |> Enum.count(&required_fields_present?/1)
        |> IO.puts

        # part 2 - 145
        read_input()
        |> Enum.count(&fully_valid?/1)
        |> IO.puts
    end
end
