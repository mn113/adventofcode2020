#!/usr/bin/env ruby

# Read whole file to be able to split extra lines
@input = File.read("../inputs/input06.txt")
@groups = @input.split("\n\n").map { |group| group.chomp }

# Sum the number of distinct letters in each group
def part1
    @groups.map { |group|
        letters = group.scan(/([a-z])/i)
        letters.uniq.count
    }
    .reduce(&:+)
end
puts part1() # 6457

# Sum the number of distinct letters appearing in every line in a group
def part2
    @groups.map { |group|
        lines = group.each_line.to_a
        ('a'..'z').to_a.map{ |c|
            lines.all?{ |line|  line.include?(c) } ? 1 : 0
        }
        .reduce(&:+)
    }
    .reduce(&:+)
end
puts part2() # 3260