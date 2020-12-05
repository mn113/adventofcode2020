input = File.read("../inputs/input04.txt")
@data = input.split("\n\n").map { |record|
    record.chomp.split(/\s/).map { |field|
        field.split(":")
    }
}

##
# Validate presence of required keys
# @param array
# @returns Boolean
def required_fields_present?(record)
    required = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    required.all?{ |key|
        record.any?{ |pair|
            pair[0] == key
        }
    }
end

##
# Validate year format
# @param string val
# @returns Boolean
def valid_year?(val, min, max)
    val.length == 4 && val.to_i >= min && val.to_i <= max
end

##
# Validate height format
# @param string val
# @returns Boolean
def valid_height?(val)
    num, unit = val.match(/^([0-9]+)(cm|in)?$/)[1..2]
    num = num.to_i
    if unit == "cm"
        num >= 150 && num <= 193
    elsif unit == "in"
        num >= 59 && num <= 76
    else
        false
    end
end

##
# Validate hair colour format
# @param string val
# @returns Boolean
def valid_hair?(val)
    !(/^#[0-9a-f]{6}$/ =~ val).nil?
end

##
# Validate eye colour format
# @param string val
# @returns Boolean
def valid_eyes?(val)
    ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].include?(val)
end

##
# Validate pid format
# @param string val
# @returns Boolean
def valid_pid?(val)
    !(/^[0-9]{9}$/ =~ val).nil?
end

##
# Validate all aspects of a record
# @returns Boolean
def fully_valid?(record)
    return false if !required_fields_present? record
    record.each{ |field|
        case field[0]
        when "byr"
            return false if !valid_year?(field[1], 1920, 2002)
        when "iyr"
            return false if !valid_year?(field[1], 2010, 2020)
        when "eyr"
            return false if !valid_year?(field[1], 2020, 2030)
        when "hcl"
            return false if !valid_hair?(field[1])
        when "hgt"
            return false if !valid_height?(field[1])
        when "ecl"
            return false if !valid_eyes?(field[1])
        when "pid"
            return false if !valid_pid?(field[1])
        end
    }
    return true
end

# part 1 - 247
p @data.count{ |r| required_fields_present? r }

# part 2 - 145
p @data.count{ |r| fully_valid? r }
