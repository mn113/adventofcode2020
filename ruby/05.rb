#!/usr/bin/env ruby

input = File.open(File.expand_path("../inputs/input05.txt", __dir__), "r")
@data = input.each_line

##
# Convert a string of binary search directions e.g. "FBFFBFB"
# to the integer resulting from its binary conversion
# @param [string] directions
# @returns [integer]
def find_row(directions)
    binary = directions.gsub("F","0").gsub("B","1")
    binary.to_i(2)
end

##
# Convert a string of binary search directions e.g. "RLL"
# to the integer resulting from its binary conversion
# @param [string] directions
# @returns [integer]
def find_col(directions)
    binary = directions.gsub("L","0").gsub("R","1")
    binary.to_i(2)
end

##
# From a boarding pass code e.g. "FBBFBFBLLR"
# calculate the seat number on a sequential grid
# @param [string] code
# @returns [integer]
def find_seat(code)
    row = find_row code.slice(0,7)
    col = find_col code.slice(7,3)
    (row * 8) + col
end

filled_seats = @data.map{ |code| find_seat code }

# part 1 - 989
lo = filled_seats.min
hi = filled_seats.max
puts hi

# part 2 - 548
for i in lo..hi do
    if !filled_seats.include?(i)
        puts i
        break
    end
end
