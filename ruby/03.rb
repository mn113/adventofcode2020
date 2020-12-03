input = File.open("../inputs/input03.txt", "r")
@grid = input.each_line.map { |row| row.chomp.split("") }
@width = @grid[0].size
@height = @grid.size

def count_trees_in_sloped_path(dx, dy)
    x = 0
    y = 0
    trees = 0
    while true do
        trees += 1 if @grid[y][x] == '#'
        x += dx
        y += dy
        x -= @width if x >= @width
        break if y >= @height
    end
    trees
end

a = count_trees_in_sloped_path(1, 1)
b = count_trees_in_sloped_path(3, 1)
c = count_trees_in_sloped_path(5, 1)
d = count_trees_in_sloped_path(7, 1)
e = count_trees_in_sloped_path(1, 2)

# part 1 = 268
p b

# part 2 = 3093068400
p a * b * c * d * e