#!/usr/bin/env ruby

@input = File.open(File.expand_path("../inputs/input13.txt", __dir__), "r")
@bus_data = @input.each_line.to_a[1].chomp.split(",")

buses = []
@bus_data.each_with_index do |n, i|
    next if n == 'x'
    buses.push({freq: n.to_i, delay: i})
end
buses.sort!{ |a,b| b[:freq] - a[:freq] }
p buses

# part 1 - 2935
time0 = 1005526
waits = buses.map{ |bus| bus[:freq] - time0.remainder(bus[:freq]) }
p "p1: #{waits.min * 587}"

# part 2
limit = 1_000_000_000_000_000

# helpfully, 2 buses both have delays which sync to zero -> combine them
37.lcm(17) # 629

ts = -68 # delay of largest frequency bus, 733
jump = 733 # freq of largest bus
p "start jump: #{jump}"

# amalgamate some bus freqs once only:
flag1 = false
flag2 = false

while ts < limit do
    ts += jump

    if !flag1 and ts % 629 == 0 # freq of next largest bus (actually, 37 and 17 in sync)
        jump *= 629
        flag1 = true
        p "new jump: #{jump}"
    end

    if !flag2 and ts % 587 == 550 # freq of next largest bus
        jump *= 587
        flag2 = true
        p "new jump: #{jump}"
    end

    # check if all buses are now properly synced
    if ts % 733 == 665 and
        ts % 587 == 550 and
        ts % 41 == 14 and
        ts % 37 == 0 and
        ts % 29 == 21 and
        ts % 23 == 9 and
        ts % 19 == 1 and
        ts % 17 == 0 and
        ts % 13 == 10
        p "p2: final ts: #{ts}" # 836024966345345
        break
    end
end
