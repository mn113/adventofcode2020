input = File.open("../inputs/input02.txt", "r")
#input = input.each_line.map{|line| line.split(",")}
input = input.each_line.map do |line|
    /(?<lo>\d+)-(?<hi>\d+) (?<letter>[a-z]+): (?<password>[a-z]+)/ =~ line.chomp

    {:lo => lo.to_i,
     :hi => hi.to_i,
     :letter => letter,
     :password => password}
end

def is_valid_part1(password, letter, lo, hi)
    num = password.count(letter)
    num >= lo && num <= hi
end

def is_valid_part2(password, letter, lo, hi)
    first = password[lo-1] == letter ? 1 : 0
    second = password[hi-1] == letter ? 1 : 0
    first + second == 1
end

# part 1
p input.select{|inp| is_valid_part1(inp[:password], inp[:letter], inp[:lo], inp[:hi])}.length

# part 2
p input.select{|inp| is_valid_part2(inp[:password], inp[:letter], inp[:lo], inp[:hi])}.length