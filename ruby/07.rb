#!/usr/bin/env ruby

require 'pp'
require 'set'

@input = File.open(File.expand_path("../inputs/input07_.txt", __dir__), "r")
@data = @input.each_line.to_a

# Extract bag types
@bags = Set.new
@data.each do |line|
    matches = line.chomp.scan(/(\w+ \w+) bag/)
    @bags.merge(matches.flatten)
end

p @bags
print "#{@bags.length} bag types\n"

@graph = Hash.new()

head_re = Regexp.new("^(#{@bags.to_a.join("|")}) bag")
tail_re = Regexp.new("(\\d+) (#{@bags.to_a.join("|")}) bag")
empty_re = Regexp.new("no other bags")

##
# Parse lines and build up a Hash of relations (parent bag => child bags)
#
@data.each do |line|
    head, tail = line.split(" contain ")
    head_matches = head_re.match(head)

    if head_matches
        head_colour = head_matches[1]
        tail_matches = tail.scan(tail_re)
        empty_matches = empty_re.match(tail)

        if empty_matches
            @graph[head_colour] = nil
        elsif tail_matches
            tail_matches.each do |pair|
                value = { amount: pair[0].to_i, colour: pair[1] }
                if !@graph[head_colour]
                    @graph[head_colour] = [value]
                else
                    @graph[head_colour].push(value)
                end
            end
        end
    end
end
#pp @graph
print "#{@graph.keys.count} Hash keys\n"
p "---"

##
# Search the graph for a path leading from start node to goal node
# @param {String} start - colour name
# @param {String} goal - colour name
def tree_walk(start, goal)
    return false if start == goal

    print "\nStart tree_walk from #{start}: "

    @visited = []
    @to_visit = []

    # @param {string} node - colour name
    def visit_node(node)
        print "#{node}, "
        @visited.push(node)
        if @graph[node]
            @to_visit.concat(@graph[node].map{ |val| val[:colour] } )
        end
    end

    visit_node(start)
    current = start

    while @to_visit.length do
        previous, current = current, @to_visit.shift()
        #p "current: #{current}"

        if current.nil?
            break
        elsif current == goal
            print "\n[FOUND SG! inside #{start}]\n"
            return true
        elsif @graph[current].nil?
            # dead end, skip
            print "0, "
            next
        elsif @graph.has_key? current
            # continue walk
            visit_node(current)
        elsif @visited.include? current
            # in a loop
            break
        end
    end
    print "[dead end inside #{start}]"
    false
end

##
# part1 - 261
# Find and sum all paths leading from a starting colour to "shiny gold"
#
valid_keys = @graph.keys.to_a.map{ |key|
    tree_walk(key, "shiny gold")
}
n = valid_keys.select{ |b| b }.count
print "\nBags leading to shiny gold: #{n}\n"

##
# part 2
# Count the total bags inside 1 shiny gold bag
#
bag_list = []
current = {amount: 1, colour: "shiny gold"}
to_visit = [current]
while to_visit.length do
    current = to_visit.shift
    bag_list.push(current[:amount])
    # count current amount, multiplied
    children = @graph[current[:colour]]
    if children
        to_visit.concat(children)
    end
end
p bag_list
