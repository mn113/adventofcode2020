#!/usr/bin/env ruby

@cups = []
@cup_links = Hash.new # cyclic linked list
@min, @max = 0, 0
@val = nil

def setup_cups(extend_to = nil)
    @cups = '459672813'.chars.map(&:to_i)
    if extend_to
        @cups += ((@max+1)..extend_to).to_a
    end
    @min, @max = @cups.min, @cups.max
    @val = @cups.first
end

def setup_cup_links()
    len = @cups.length
    @cups.each_with_index do |c,i|
        @cup_links[c] = @cups[(i+1) % len]
    end
end

def move()
    # pick up next 3
    p1 = @cup_links[@val]
    p2 = @cup_links[p1]
    p3 = @cup_links[p2]
    # split & reconnect, omitting 3 links
    @cup_links[@val] = @cup_links[p3]

    # choose dest by decreasing and looping round
    dest = @val
    while true do
        dest -= 1
        dest = @max if dest < @min
        break unless [p1,p2,p3].include? dest
    end

    # re-insert picked 3
    @cup_links[dest], @cup_links[p3] = p1, @cup_links[dest]

    # select next cup along
    @val = @cup_links[@val]
end

def solve(part, moves)
    moves.times do |i|
        move()
        p i if i % 1000000 == 0
    end

    c2 = @cup_links[1]
    c3 = @cup_links[c2]
    c4 = @cup_links[c3]
    c5 = @cup_links[c4]
    c6 = @cup_links[c5]
    c7 = @cup_links[c6]
    c8 = @cup_links[c7]
    c9 = @cup_links[c8]

    if part == 'p1'
        print "p1: #{[c2,c3,c4,c5,c6,c7,c8,c9].join}\n"
    else
        print "p2: #{c2} * #{c3} = #{c2 * c3}\n"
    end
end

# part 1 - 68245739
setup_cups()
setup_cup_links()
solve('p1', 100)

# # part 2 - 219634632000
setup_cups(1_000_000)
setup_cup_links()
solve('p2', 10_000_000)
