#!/usr/bin/env ruby

require 'pp'

@rules = {
    dep_loc: [29,766,786,950],
    dep_stat: [40,480,491,949],
    dep_plat: [46,373,397,957],
    dep_track: [33,657,673,970],
    dep_date: [31,433,445,961],
    dep_time: [33,231,250,966],
    arr_loc: [48,533,556,974],
    arr_stat: [42,597,620,957],
    arr_plat: [32,119,140,967],
    arr_track: [28,750,762,973],
    class: [26,88,101,950],
    duration: [30,271,293,974],
    price: [33,712,718,966],
    route: [49,153,159,953],
    row: [36,842,851,972],
    seat: [43,181,194,955],
    train: [29,500,513,964],
    type: [32,59,73,974],
    wagon: [47,809,816,957],
    zone: [44,451,464,955]
}
@rules.each do |k,ranges|
    @rules[k] = (ranges[0]..ranges[1]).to_a.concat((ranges[2]..ranges[3]).to_a)
end

@tickets = File.open(File.expand_path("../inputs/input16_nearby.txt", __dir__), "r")
    .each_line.map{ |line| line.chomp.split(",").map(&:to_i) }

@numbers = @tickets.flatten.sort
@valid_nums = @rules.values.flatten.sort

def is_valid_ticket(t)
    t.all?{ |n| @valid_nums.include? n }
end

# part 1
@invalid_nums = @numbers.reject{ |n| @valid_nums.include? n }
p @invalid_nums.reduce(&:+) # 21980


@my_ticket = "151,103,173,199,211,107,167,59,113,179,53,197,83,163,101,149,109,79,181,73".split(",").map(&:to_i)
@tickets.push(@my_ticket)
@valid_tickets = @tickets.select{ |t| is_valid_ticket t }

@rule_columns = Hash.new

# take each rule range and each data column;
# build a hash of rules and columns which can be valid for all tickets
@rules.each do |rule,rule_nums|
    if !@rule_columns.has_key? rule
        @rule_columns[rule] = []
    end
    # 20 columns to check
    (0...20).each do |i|
        column_i = @valid_tickets.map{ |t| t[i] }
        col_ok = true
        column_i.each_with_index do |num,i|
            if !rule_nums.include? num
                col_ok = false
                break
            end
        end
        if col_ok
            @rule_columns[rule].push(i)
        end
    end
end

pp @rule_columns

# output of pp, sorted by length:
#  :seat=>     [10],
#  :arr_loc=>  [2, 10],
#  :row=>      [2, 10, 11],
#  :arr_track=>[2, 10, 11, 17],
#  :duration=> [2, 4, 10, 11, 17],
#  :wagon=>    [2, 4, 10, 11, 13, 17],
#  :type=>     [2, 3, 4, 10, 11, 13, 17],
#  :train=>    [2, 3, 4, 6, 10, 11, 13, 17],
#  :dep_time=> [2, 3, 4, 6, 10, 11, 12, 13, 17],
#  :dep_stat=> [2, 3, 4, 5, 6, 10, 11, 12, 13, 17],
#  :dep_loc=>  [1, 2, 3, 4, 5, 6, 10, 11, 12, 13, 17],
#  :dep_track=>[1, 2, 3, 4, 5, 6, 7, 10, 11, 12, 13, 17],
#  :dep_plat=> [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 17],
#  :dep_date=> [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 15, 17],
#  :arr_stat=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 17],
#  :arr_plat=> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 17],
#  :price=>    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 17, 18],
#  :route=>    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 18],
#  :zone=>     [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
#  :class=>    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19],

# part 2
# product of my ticket's dep_* values
dep_indices = [12,5,1,7,9,15]
p dep_indices.map{ |i| @my_ticket[i] }.reduce(&:*) # 1439429522627
