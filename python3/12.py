#! /usr/bin/env python3

def read_input():
    with open('../inputs/input12.txt') as fp:
        lines = fp.readlines()
        return [[line[0], int(line.strip()[1:])] for line in lines]

instructions = read_input()

class Ship:
    compass = ['N', 'E', 'S', 'W']
    vectors = { 'N': (0,-1), 'E': (1,0), 'S': (0,1), 'W': (-1,0) }

    @classmethod
    def get_compass(cls):
        return cls.compass

    @classmethod
    def get_vectors(cls):
        return cls.vectors

    def __init__(self, initial_coords, initial_dir):
        self.x = initial_coords[0]
        self.y = initial_coords[1]
        self.dir = initial_dir

    # Set a new direction
    def turn(self, side = 'R', degrees = 0):
        compass_index = self.get_compass().index(self.dir)
        quarter_turns = degrees // 90
        if side == 'R':
            compass_index += quarter_turns
        else:
            compass_index -= quarter_turns
        self.dir = self.get_compass()[compass_index % 4]
        self.report()

    # Move some steps in current facing direction
    def advance(self, amount = 1):
        vects = self.get_vectors()
        self.x += vects[self.dir][0] * amount
        self.y += vects[self.dir][1] * amount
        self.report()

    # Move some steps along X axis, without changing facing direction
    def translateX(self, x):
        self.x += x
        self.report()

    # Move some steps along Y axis, without changing facing direction
    def translateY(self, y):
        self.y += y
        self.report()

    # Move some steps in a direction, without changing facing direction
    def translate(self, dir, amount = 1):
        vects = self.get_vectors()
        self.x += vects[dir][0] * amount
        self.y += vects[dir][1] * amount
        self.report()

    def report(self):
        # print("at", (self.x, self.y), "facing", self.dir)
        pass


class WaypointFollowingShip(Ship):
    def __init__(self, initial_coords, initial_dir, waypoint_coords):
        super().__init__(initial_coords, initial_dir)

        # waypoint's coords are relative to the ship
        self.waypoint = {'x':0, 'y':0}
        self.waypoint['x'] = waypoint_coords[0]
        self.waypoint['y'] = waypoint_coords[1]

    # move the waypoint NESW
    def move_waypoint(self, dir, amount = 1):
        vects = self.get_vectors()
        self.waypoint['x'] += vects[dir][0] * amount
        self.waypoint['y'] += vects[dir][1] * amount
        self.report()

    # rotate the waypoint around the ship
    def rotate_waypoint(self, side = 'R', degrees = 0):
        # x, y = self.waypoint['x'], self.waypoint['y']
        quarter_turns = degrees // 90
        while quarter_turns:
            if side == 'R':
                self.waypoint['x'], self.waypoint['y'] = -self.waypoint['y'], self.waypoint['x']
            else:
                self.waypoint['x'], self.waypoint['y'] = self.waypoint['y'], -self.waypoint['x']

            quarter_turns -= 1
        self.report()

    # travel to the waypoint over and over
    def goto_waypoint(self, times):
        while times:
            self.translateX(self.waypoint['x'])
            self.translateY(self.waypoint['y'])
            times -= 1
        self.report()

    def report(self):
        # print("at", (self.x, self.y), "facing", self.dir, "waypoint at", (self.waypoint['x'], self.waypoint['y']))
        pass


# top left (0,0): positive x is East, positive y is South
ship = Ship((0,0), 'E')

# part 1 - 1645
for i in range(len(instructions)):
    [c, d] = instructions[i]
    if c in 'RL':
        ship.turn(c, d)
    elif c in 'NESW':
        ship.translate(c, d)
    elif c == 'F':
        ship.advance(d)

print("p1", abs(ship.x) + abs(ship.y))


wpship = WaypointFollowingShip((0,0), 'E', (10, -1))

# part 2
for i in range(len(instructions)):
    [c, d] = instructions[i]
    if c in 'RL':
        wpship.rotate_waypoint(c, d)
    elif c in 'NESW':
        wpship.move_waypoint(c, d)
    elif c == 'F':
        wpship.goto_waypoint(d)

print("p2", abs(wpship.x) + abs(wpship.y))
