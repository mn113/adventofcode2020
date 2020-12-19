require 'set'
require 'pp'

@initial = """..##.#.#
##....#.
....####
#..##...
#..#.##.
.#..#...
##...##.
.#...#.."""

# ingest and store "on" cells - anything else assumed "off"
def ingest_3d(initial)
    on = Set.new
    initial
    .split("\n")
    .each_with_index do |line,y|
        line.chars.each_with_index do |c,x|
            on.add({x:x, y:y, z:0}) if c == '#'
        end
    end
    on
end

@on = ingest_3d(@initial)

def is_on?(cell)
    @on.include? cell
end

# gets the 26 neighbours of a cell in a 3x3 cube around it
# those which are "on"
def get_on_neighbs_3d(cell)
    deltas = [
        # dz = -1, 3x3
        [-1,-1,-1], [0,-1,-1], [1,-1,-1],
        [-1, 0,-1], [0, 0,-1], [1, 0,-1],
        [-1, 1,-1], [0, 1,-1], [1, 1,-1],
        # dz = 0, 3x3 without centre
        [-1,-1, 0], [0,-1, 0], [1,-1, 0],
        [-1, 0, 0],            [1, 0, 0],
        [-1, 1, 0], [0, 1, 0], [1, 1, 0],
        # dz = 1, 3x3
        [-1,-1, 1], [0,-1, 1], [1,-1, 1],
        [-1, 0, 1], [0, 0, 1], [1, 0, 1],
        [-1, 1, 1], [0, 1, 1], [1, 1, 1]
    ]
    on_neighbs = deltas
        .map{ |d| {
            x: cell[:x] + d[0],
            y: cell[:y] + d[1],
            z: cell[:z] + d[2]
        }}
        .select{ |nb| is_on? nb }
end

# initial grid bounds (any dimension)
@lo = 0
@hi = 7

# consider all cells in a 3D grid, turn next copy of a cell on in certain conditions
def advance_3d()
    @lo, @hi = @lo - 1, @hi + 1

    newon = Set.new
    (@lo..@hi).to_a.each do |z|
        (@lo..@hi).to_a.each do |y|
            (@lo..@hi).to_a.each do |x|
                cell = {x:x, y:y, z:z}
                neighbs = get_on_neighbs_3d(cell)
                if is_on? cell
                    if neighbs.length.between?(2,3)
                        newon.add cell
                    end
                else
                    if neighbs.length == 3
                        newon.add cell
                    end
                end
            end
        end
    end
    @on = newon
end

# part 1 - 202
6.times do
    advance_3d()
end
p "p1: #{@on.size}"


# ingest "on" cells
def ingest_4d(initial)
    on = Set.new
    initial
    .split("\n")
    .each_with_index do |line,y|
        line.chars.each_with_index do |c,x|
            on.add({w:0, x:x, y:y, z:0}) if c == '#'
        end
    end
    on
end

# Set up
@on = ingest_4d(@initial)

# gets the 80 neighbours of a cell in a 4x4 hypercube around it
# those which are "on"
def get_on_neighbs_4d(cell)
    deltas = []
    [-1,0,1].each do |z|
        [-1,0,1].each do |y|
            [-1,0,1].each do |x|
                [-1,0,1].each do |w|
                    # add every cell apart from {0,0,0,0}
                    deltas.push({ w:w, x:x, y:y, z:z }) unless w == 0 and x == 0 and y == 0 and z == 0
                end
            end
        end
    end
    deltas.map{ |d| {
        w: cell[:w] + d[:w],
        x: cell[:x] + d[:x],
        y: cell[:y] + d[:y],
        z: cell[:z] + d[:z]
    }}
    .select{ |nb| is_on? nb }
end

# initial grid bounds (any dimension)
@lo_xy = 0
@hi_xy = 7
@lo_wz = @hi_wz = 0

# consider all cells in a 3D grid, turn next copy of a cell on in certain conditions
def advance_4d()
    @lo_xy, @hi_xy = @lo_xy - 1, @hi_xy + 1
    @lo_wz, @hi_wz = @lo_wz - 1, @hi_wz + 1

    newon = Set.new
    (@lo_wz..@hi_wz).to_a.each do |z|
        (@lo_xy..@hi_xy).to_a.each do |y|
            (@lo_xy..@hi_xy).to_a.each do |x|
                (@lo_wz..@hi_wz).to_a.each do |w|
                    cell = {w:w, x:x, y:y, z:z}
                    neighbs = get_on_neighbs_4d(cell)
                    if is_on? cell
                        if neighbs.length.between?(2,3)
                            newon.add cell
                        end
                    else
                        if neighbs.length == 3
                            newon.add cell
                        end
                    end
                end
            end
        end
    end
    @on = newon
end

# part 2 - 2028
6.times do |i|
    advance_4d()
end
p "p2: #{@on.size}"
