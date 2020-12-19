#!/usr/bin/env ruby

@input = File.open(File.expand_path("../inputs/input14.txt", __dir__), "r")
@lines = @input.each_line.to_a

# memory respresentations for part 1 & 2
@register1 = Hash.new(0)
@register2 = Hash.new(0)

@bitmask = 'X'*36

# Apply bitmask to a value
# @param {Number} value, base 10, to operate on
# @param {String} bitmask (length 36)
# @returns {String} binary representation, length 36
def apply_bitmask(value, mask_str)
    value_str = value.to_s(2).rjust(36, '0')
    mask_str.chars.each_with_index{ |c,i|
        if c != 'X'
            value_str[i] = c
        end
    }
    value_str
end

# Assign bitmasked value into a specific memory address
# @param {Number} index of registers
# @param {Number} value
# @param {String} bitmask (length 36)
def assign_via_mask(index, value, bitmask)
    @register1[index] = apply_bitmask(value, bitmask).to_i(2)
end

@lines.each do |line|
    if line.start_with? "mask"
        @bitmask = line.chomp.split(" = ")[1]
    else
        if m = line.chomp.match(/^mem\[(\d+)\] = (\d+)$/)
            assign_via_mask(m[1].to_i, m[2].to_i, @bitmask)
        end
    end
end

# part 1 - sum of registers values - 13105044880745
ans = @register1.values.select{ |v| v > 0 }.reduce(&:+)
p "p1: #{ans}"


# Apply bitmask to a value. Unknown 'X' values end up in result
# @param {Number} value, base 10, to operate on
# @param {String} mask_str (length 36)
# @returns {String} length 36
def apply_bitmask_quantumly(value, mask_str)
    value_str = value.to_s(2).rjust(36, '0')
    mask_str.chars.each_with_index{ |c,i|
        if c == 'X'
            value_str[i] = 'X'
        elsif c == '1'
            value_str[i] = '1'
        end
    }
    value_str
end

# Generates all possible values of a binary strng with unknown 'X' characters
# @param {String} address made of '0', '1', 'X'
# @returns {Number[]} all possible decimal values
def combine_address(address)
    base_val = address.gsub('X', '0').to_i(2)
    address.reverse!
    x_indices = [] # reversed string indices of X's
    address.chars.each_index{ |i|
        x_indices.push(i) if address[i] == 'X'
    }

    combos = (1..x_indices.length).map do |n|
        x_indices.combination(n).map do |fls|
            base_val + fls.reject(&:nil?).map{ |f| 2**f }.reduce(&:+)
        end
        .to_a
    end
    [base_val].concat(combos.flatten)
end

# Assign bitmasked value into a specific memory address
# @param {Number} index of registers
# @param {Number} value
# @param {String} bitmask (length 36)
def assign_many_via_mask(index, value, bitmask)
    quantum_address = apply_bitmask_quantumly(index, bitmask)
    addresses = combine_address(quantum_address)
    addresses.each{ |addy| @register2[addy] = value }
end

@lines.each_with_index do |line,i|
    if line.start_with? "mask"
        @bitmask = line.chomp.split(" = ")[1]
    else
        if m = line.chomp.match(/^mem\[(\d+)\] = (\d+)$/)
            assign_many_via_mask(m[1].to_i, m[2].to_i, @bitmask)
        end
    end
end

# part 2 - sum of registers values - 3505392154485
ans = @register2.values.select{ |v| v > 0 }.reduce(&:+)
p "p2: #{ans}"
