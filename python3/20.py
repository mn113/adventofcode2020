#! /usr/bin/env python3

SIDEWORDS = {'t': 'top', 'b': 'bottom', 'r': 'right',  'l': 'left'}
FLIPWORDS = {True: 'flipped', False: 'normal'}

class Tile:
    edges_cw = []
    edges_ccw = []
    flipped_edges_cw = []
    flipped_edges_ccw = []

    def __init__(self, id, data, rotations = 0, flipped = False):
        self.id = id
        self.data = [row.strip() for row in data]
        self.rotations = rotations
        self.flipped = flipped
        self.make_edges()

    def __str__(self):
        return "Tile {}\n".format(self.id) + "\n".join(self.data) + "\n"

    @property
    def top(self):
        return self.data[0]

    @property
    def bottom(self):
        return self.data[-1][::-1]

    @property
    def left(self):
        return "".join([row[0] for row in self.data][::-1])

    @property
    def right(self):
        return "".join([row[-1] for row in self.data])

    @property
    def centre(self):
        return ["".join(row[1:-1]) for row in self.data[1:-1]]

    def flipVert(self):
        self.data = self.data[::-1]
        self.flipped = not self.flipped

    def flipHoriz(self):
        self.data = [row[::-1] for row in self.data]
        self.flipped = not self.flipped

    def rotateClockwise(self):
        self.data = ["".join(tup) for tup in zip(*self.data[::-1])]

    def make_edges(self):
        # regular clockwise
        top = self.data[0]
        right = "".join([row[-1] for row in self.data])
        bottom = self.data[-1][::-1]
        left = "".join([row[0] for row in self.data][::-1])
        self.edges_cw = {'t': top, 'r': right, 'b': bottom, 'l': left}

        # regular anticlockwise
        self.edges_ccw = {'t': top[::-1], 'l': left[::-1], 'b': bottom[::-1], 'r': right[::-1]}

        # flipped variants
        self.flipVert()
        top = self.data[0]
        right = "".join([row[-1] for row in self.data])
        bottom = self.data[-1][::-1]
        left = "".join([row[0] for row in self.data][::-1])
        self.flipped_edges_cw = {'t': top, 'r': right, 'b': bottom, 'l': left}
        self.flipped_edges_ccw = {'t': top[::-1], 'l': left[::-1], 'b': bottom[::-1], 'r': right[::-1]}
        self.flipVert()

    def get_edges(self, isClockwise = False, isFlipped = False):
        if isFlipped:
            if isClockwise:
                return self.flipped_edges_cw
            else:
                return self.flipped_edges_ccw
        else:
            if isClockwise:
                return self.edges_cw
            else:
                return self.edges_ccw


tiles = {}
with open('../inputs/input20.txt') as fp:
    lines = fp.readlines()
    for i in range(len(lines)):
        line = lines[i]
        if len(line) == 0:
            pass
        elif line[0:4] == 'Tile':
            id = int(line[5:9])
            data = lines[i+1:i+11]
            tiles[id] = Tile(id, data)
            i += 11

print(len(tiles), 'tiles')

tt = Tile(1, ["TTT", "MMM", "BBB"])
tt.rotateClockwise()

def findMatchingTiles(id1, matchGoal = 0):
    edges1 = tiles[id1].get_edges(True)
    matches = 0
    for id2 in keylist:
        if id1 == id2:
            continue
        # get opposite-direction edges of 2 tiles
        # first tile is static, second can move, rotate and flip
        for isFlipped in [True, False]:
            edges2 = tiles[id2].get_edges(False, isFlipped)
            for t2side in 'trbl':
                if edges2[t2side] in edges1.values():
                    matches += 1
                    t1side = [s for s in edges1.keys() if edges1[s] == edges2[t2side]][0]
                    flipped = FLIPWORDS[isFlipped]
                    print('Tile {} {} CW fits Tile {} {} {} CCW'.format(id1, SIDEWORDS[t1side], id2, flipped, SIDEWORDS[t2side]))
    if matches == matchGoal:
        print('>>> Tile {} had {} matches!'.format(id1, matches))

def findMatchingEdge(id1):
    pass

# attempt to find corners
keylist = sorted(list(tiles.keys()))
for k in keylist:
    findMatchingTiles(k, 2)

corners = [1151, 1663, 2659, 3079]
keylist = [k for k in keylist if k != 1151]

# part 1 - 15670959891893
print(1151 * 1663 * 2659 * 3079)


# start finding edges
if True:
    findMatchingTiles(1151,2) # 1303,2341
    findMatchingTiles(1303,2) # 2111,3187
    findMatchingTiles(2341,2) # 2311,3187
    keylist = [k for k in keylist if k not in [1303,2341,2111,3187,2311]]
    print(len(keylist))
    findMatchingTiles(2111,2) # 2617,2741
    findMatchingTiles(2311,2) # 1873,3943
    keylist = [k for k in keylist if k not in [2617,2741,1873,3943]]
    print(len(keylist))
    findMatchingTiles(1873,2) # 2269,3229
    findMatchingTiles(2617,2) # 1301,3119
    findMatchingTiles(3943,2) # 3259
    keylist = [k for k in keylist if k not in [2269,3229,1301,3119,3259]]
    print(len(keylist))
    findMatchingTiles(2269,2) # 2731,3209
    findMatchingTiles(3259,2) # 3001,3217
    findMatchingTiles(3119,2) # 1451,1283
    keylist = [k for k in keylist if k not in [2731,3209,3001,3217,1451,1283]]
    print(len(keylist))
    findMatchingTiles(2731,2) # 2909,3181
    findMatchingTiles(3217,2) # 2791,2887
    findMatchingTiles(1283,2) # 2137,2539
    keylist = [k for k in keylist if k not in [2909,3181,2791,2887,2137,2539]]
    print(len(keylist))
    findMatchingTiles(3181,2) # 1879,2531
    findMatchingTiles(2791,2) # 2551,3169
    findMatchingTiles(2539,2) # 1361,2657
    findMatchingTiles(2137,2) # 2293
    keylist = [k for k in keylist if k not in [1879,2531,2551,3169,1361,2657,2293]]
    print(len(keylist))
    findMatchingTiles(2531,2) # 1487,3251
    findMatchingTiles(3169,2) # 1571,3739
    findMatchingTiles(2551,2) # 2383
    findMatchingTiles(1361,2) # 1481,2549
    findMatchingTiles(2293,2) # 1259,3727
    keylist = [k for k in keylist if k not in [1487,3251,1571,3739,2383,1481,2549,1259,3727]]
    print(len(keylist))
    findMatchingTiles(1487,2) # 1291,1759
    findMatchingTiles(3739,2) # 1171,1511
    findMatchingTiles(2383,2) # 1637,2083
    findMatchingTiles(1481,2) # 2957,3049
    findMatchingTiles(3727,2) # 1061,3637
    keylist = [k for k in keylist if k not in [1291,1759,1171,1511,1637,2083,2957,3049,1061,3637]]
    print(len(keylist))
    findMatchingTiles(1291,2) # 3067,3167
    findMatchingTiles(1171,2) # 1723,3203
    findMatchingTiles(1637,2) # 2423,3011
    findMatchingTiles(2957,2) # 1117,2963
    findMatchingTiles(1061,2) # 1409,3533
    findMatchingTiles(3637,2) # 2671
    keylist = [k for k in keylist if k not in [3067,3167,1723,3203,2423,3011,1117,2963,1409,3533,2671]]
    print(len(keylist))
    findMatchingTiles(3167,2) # 3079,3803
    findMatchingTiles(3203,2) # 2711,3299
    findMatchingTiles(2423,2) # 1933,3121
    findMatchingTiles(1117,2) # 1783,2971
    findMatchingTiles(1409,2) # 3539,3911
    findMatchingTiles(2671,2) # 1493,2659
    keylist = [k for k in keylist if k not in [3079,3803,2711,3299,1933,3121,1783,2971,3539,3911,1493,2659]]
    print(len(keylist))
    findMatchingTiles(3803,2) # 1019
    findMatchingTiles(2711,2) # 1627,2221
    findMatchingTiles(1933,2) # 2503,3083
    findMatchingTiles(1783,2) # 2161,3191
    findMatchingTiles(3539,2) # 3257,3671
    findMatchingTiles(2659,2) # 1619
    keylist = [k for k in keylist if k not in [1019,1627,2221,2503,3083,2161,3191,3257,3671,1619]]
    print(len(keylist))
    findMatchingTiles(1019,2) # ?
    findMatchingTiles(1627,2) # ?
    findMatchingTiles(2503,2) # 1733,2833
    findMatchingTiles(2161,2) # 1601,3947
    findMatchingTiles(3671,2) # 2351,3253
    keylist = [k for k in keylist if k not in [1733,2833,1601,3947,2351,3253]]
    print(len(keylist))
    findMatchingTiles(3253,2) #
    findMatchingTiles(1601,2) # 2333,3691
    findMatchingTiles(1733,2) # 2011,2543
    keylist = [k for k in keylist if k not in [2333,3691,2011,2543]]
    print(len(keylist))
    findMatchingTiles(2543,3) # 1877,3571,3797
    findMatchingTiles(2333,2) # 2027,3767
    findMatchingTiles(3691,2) # 3613
    keylist = [k for k in keylist if k not in [1877,3571,3797,2027,3767,3613]]
    print(len(keylist))
    findMatchingTiles(3797,3) # 1039,2447,3989
    findMatchingTiles(3767,2) # 2063,3329
    findMatchingTiles(3613,3) # 2243,2273,3697
    keylist = [k for k in keylist if k not in [1039,2447,3989,2063,3329,2243,2273,3697]]
    print(len(keylist))
    findMatchingTiles(2351,1) # 2591
    findMatchingTiles(2243,1) # 1531
    keylist = [k for k in keylist if k not in [2591,1531]]
    print(len(keylist))
    findMatchingTiles(1039,3) # 2371,2467,3461
    findMatchingTiles(2063,2) # 1009,2851
    findMatchingTiles(3697,2) # 1229,2789
    keylist = [k for k in keylist if k not in [2371,2467,3461,1009,2851,1229,2789]]
    print(len(keylist))
    findMatchingTiles(2371,2) # 1049,1801
    findMatchingTiles(2851,2) # 1847,3307
    findMatchingTiles(1229,1) # 3023
    keylist = [k for k in keylist if k not in [1049,1801,1847,3307,3023]]
    print(len(keylist))
    findMatchingTiles(1801,2) # 1543,2339
    findMatchingTiles(3307,2) # 1201,1567
    keylist = [k for k in keylist if k not in [1543,2339,1201,1567]]
    print(len(keylist))
    findMatchingTiles(1543,2) # 2473,3617
    findMatchingTiles(1201,2) # 1381
    findMatchingTiles(3617,2) # 1499,2713
    keylist = [k for k in keylist if k not in [2473,3617,1381,1499,2713]]
    print(len(keylist))
    findMatchingTiles(2467,2) # 1153,1997
    keylist = [k for k in keylist if k not in [1153,1997]]
    print(keylist)
    print('---')

ids = [
    [1151,2341,2311,1873,2269,2731,3181,2531,1487,1291,3167,3079],
    [1303,3187,3943,3229,3209,2909,1879,3251,1759,3067,3803,1019],
    [2111,2741,3259,3217,2791,3169,3739,1171,3203,2711,1627,2647],
    [2617,1301,3001,2887,2551,1571,1511,1723,3299,2221,3823,2819],
    [3119,1451,3089,2131,2383,1637,2423,3121,2153,1721,1153,2459],
    [1283,2539,1361,2549,2083,3011,1933,3083,1877,2447,2467,1997],
    [2137,2657,1481,2957,1117,2971,2503,1733,2543,3797,1039,3461],
    [2293,1259,3049,2963,1783,3191,2833,2011,3571,3989,2371,1049],
    [3727,1061,1409,3911,2161,1601,2333,3767,2063,1009,1801,2339],
    [3637,3533,3539,3257,3947,3691,2027,3329,2851,1847,1543,2473],
    [2671,1493,3671,2351,2243,3613,3697,2789,3307,1201,3617,2713],
    [2659,1619,3253,2591,1531,2273,1229,3023,1567,1381,1499,1663]
]
flips = [
    [0,1,0,1,1,0,1,1,0,0,0,1],
    [0,0,0,1,0,1,1,0,0,1,0,0],
    [0,1,1,0,0,0,0,1,0,1,0,0],
    [0,1,0,1,0,0,0,1,0,0,1,0],
    [0,0,1,1,0,0,1,1,1,0,0,0],
    [0,0,0,0,0,1,0,0,0,1,1,0],
    [0,0,0,1,0,0,0,1,1,0,0,0],
    [0,1,0,1,0,1,0,0,0,1,0,1],
    [1,0,1,0,0,0,1,0,0,0,0,0],
    [1,1,0,0,1,0,0,0,0,0,1,1],
    [0,1,1,1,1,0,1,1,0,1,1,0],
    [1,1,1,0,0,1,0,0,0,0,0,0]
]
rots = [
    [0,3,0,2,3,0,1,2,3,0,2,2],
    [3,3,3,3,0,2,3,2,2,3,3,1],
    [3,2,1,1,2,0,0,2,1,1,3,2],
    [2,1,1,2,2,2,1,2,2,2,3,0],
    [0,1,2,2,3,0,3,3,1,0,0,1],
    [1,2,1,0,0,3,2,0,3,2,3,1],
    [0,3,0,2,1,3,0,2,1,3,3,2],
    [0,1,3,2,1,3,1,3,0,2,3,3],
    [1,2,3,2,1,3,2,1,0,1,1,2],
    [1,2,2,0,2,1,3,3,0,2,2,1],
    [0,2,3,1,1,3,1,1,1,2,1,0],
    [2,3,3,3,3,2,0,1,1,3,1,3]
]


def compareEdges(e1, e2, x, y, label):
    if e1 == e2[::-1]:
        return True
    else:
        print('mismatch [{}][{}] {} {} {}'.format(y, x, label, e1, e2[::-1]))
        return False

# set up image array, 144 distinct Nones
image = [
    [None for x in range(12)]
]
for i in range(11):
    image.append(image[i][:])

# 80x80, strings
bigimage = [""] * 96

for y in range(1,11):
    for x in range(1,11):
        id, rot, flip = ids[y][x], rots[y][x], flips[y][x]
        if id:
            t = tiles[id]
            if flip:
                t.flipVert()
            while rot > 0:
                t.rotateClockwise()
                rot -= 1
            image[y][x] = t
            # check edges (top / left)
            ok = True
            if y > 0 and image[y-1][x]:
                ok = compareEdges(t.top, image[y-1][x].bottom, x, y, 'top')
            if x > 0 and image[y][x-1]:
                ok = compareEdges(t.left, image[y][x-1].right, x, y, 'left')
            if ok:
                pixels = t.centre
                for yy in range(8):
                    bigimage[(y*8) + yy] += pixels[yy]
            else:
                raise ValueError("Fix grid")

bigimage = [row for row in bigimage if len(row) > 0]

# set right orientation
bigimage = bigimage[::-1]

                  #
#    ##    ##    ###
 #  #  #  #  #  #
monster = [
    (1,0), (2,1), # (y,x)
    (2,4), (1,5), (1,6), (2,7),
    (2,10), (1,11), (1,12), (2,13),
    (2,16), (1,17), (1,18), (1,19), (0,18)
]

# find & convert monsters
print(len(bigimage), len(bigimage[0]))
for y in range(78):
    for x in range(61):
        if bigimage[y+1][x] == '#': # tail piece
            # print("try:")
            for coord in monster:
                # print(coord, bigimage[y + coord[0]][x + coord[1]])
                if bigimage[y + coord[0]][x + coord[1]] == '.':
                    break
            else:
                # found one
                print('m @ [{}][{}]'.format(y,x))
                for coord in monster:
                    row = bigimage[y + coord[0]]
                    # replace # with O
                    bigimage[y + coord[0]] = row[:x + coord[1]] + 'O' + row[x + coord[1] + 1:]

print("\n".join(bigimage))

# remaining waves
print("p2:", len([c for c in "".join(bigimage) if c == "#"]))
