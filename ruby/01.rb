Year = 2020
input = File.open("../inputs/input01.txt", "r")
input = input.each_line.map(&:to_i).sort().reject{|x| x > Year}
limit = input.size - 1

# part 1

for i in (0..limit-1) do
  for j in (i+1..limit) do
    sum = input[i] + input[j]
    if sum > Year then
      break
    elsif sum == Year then
      p "P1: #{input[i] * input[j]}"
      break
    end
  end
end

# part 2

for i in (0..limit-2) do
  for j in (i+1..limit-1) do
    for k in (j+1..limit) do
      sum = input[i] + input[j] + input[k]
      if sum > Year then
        break
      elsif sum == Year then
        p "P2: #{input[i] * input[j] * input[k]}"
        break
      end
    end
  end
end

# P1: 1005459
# P2: 92643264