#! /usr/bin/env python3

part = 1

def read_input():
    with open('../inputs/input11.txt') as fp:
        lines = fp.readlines()
        return [line.strip() for line in lines]

class Seat:
    def __init__(self, x, y, state):
        self.x = x
        self.y = y
        self.state = state

    def __str__(self):
        return self.state

    def isEdge(self):
        return self.state in '_|'

    def isFloor(self):
        return self.state == '.'

    def isEmptySeat(self):
        return self.state == 'L'

    def isFilledSeat(self):
        return self.state == '#'

    # @returns Seat[]
    def neighbours(self):
        global seating
        neighbs = {
            'W': seating[self.y][self.x - 1],
            'E': seating[self.y][self.x + 1],
            'S': seating[self.y + 1][self.x],
            'N': seating[self.y - 1][self.x],
            'NW': seating[self.y - 1][self.x - 1],
            'SW': seating[self.y + 1][self.x - 1],
            'NE': seating[self.y - 1][self.x + 1],
            'SE': seating[self.y + 1][self.x + 1]
        }
        return list(neighbs.values())

    # @returns Seat[]
    def line_of_sight_seats(self):
        dirs = {
            'N': (-1,0),
            'NE': (-1,1),
            'E': (0,1),
            'SE': (1,1),
            'S': (1,0),
            'SW': (1,-1),
            'W': (0,-1),
            'NW': (-1,-1)
        }

        # look for first filled, empty or edge seat in a direction
        def look_at_seat(direction):
            pos = (self.y, self.x)
            # do not take more than d steps from original pos
            while 1:
                pos = (pos[0] + direction[0], pos[1] + direction[1])
                seat = seating[pos[0]][pos[1]]
                if not seat.isFloor():
                    return seat

        return [look_at_seat(direction) for direction in list(dirs.values())]

    def get_new_state(self):
        # skip floors and edges
        if self.isEdge() or self.isFloor():
            return self.state

        if part == 1:
            tolerance = 4
            filled_neighbours = [nb for nb in self.neighbours() if nb.isFilledSeat()]
        else:
            tolerance = 5
            filled_neighbours = [nb for nb in self.line_of_sight_seats() if nb.isFilledSeat()]


        # node empty and no filled neighbs -> filled
        if self.isEmptySeat() and len(filled_neighbours) == 0:
            return '#'

        # node filled and 4+ filled neighbs -> empty
        elif self.isFilledSeat() and len(filled_neighbours) >= tolerance:
            return 'L'

        return self.state


# generate string snapshot of current seating area, for state comparison
# @returns {String}
def hash_seating(seating):
    return "".join(["".join([str(seat) for seat in row]) for row in seating])


# pad grid with | and _ to avoid out-of-bounds errors:
# @param {string[]} grid
def pad_grid(grid):
    pgrid = []
    # sides
    for y in range(len(grid)):
        pgrid += ["|" + grid[y] + "|"]
    # top, bottom
    horiz = "_" * len(pgrid[0])
    return [horiz] + pgrid + [horiz]


diagram = pad_grid(read_input())

# set up two 2D arrays, for current and next state
seating = []
next_seating = []

# fill initial seating
for y, line in enumerate(diagram):
    seating += [[]]
    for x, char in enumerate(line):
        seating[y] += [Seat(x, y, char)]

# one iteration of time
def run_step(i):
    global seating, next_seating

    # new empty seating before filling from current
    next_seating = []

    # fill next_seating
    for y, row in enumerate(seating):
        next_seating += [[]]
        for x, seat in enumerate(row):
            next_seating[y] += [Seat(seat.x, seat.y, seat.get_new_state())]


# run time and keep comparing hashes to detect stable state
i = 0
while 1:
    i += 1
    run_step(i)
    # progress...
    if i % 20 == 0:
        print(i, hash_seating(next_seating))

    if hash_seating(seating) == hash_seating(next_seating):
        # part 1 - number of full seats, once stable - 2183
        # part 2 - same - 1990
        print(hash_seating(seating).count("#"), "full seats")
        break
    else:
        # shift seating states before next loop
        seating, next_seating = next_seating, []
