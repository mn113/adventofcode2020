#! /usr/bin/env python3

def read_input():
    with open('../inputs/input10.txt') as fp:
        lines = fp.readlines()
        return [int(line) for line in lines]

# adaptors = sorted([1,4,5,6,7,10,11,12,15,16,19])
# adaptors = sorted([28,33,18,42,31,14,46,20,48,47,24,23,49,45,19,38,39,11,1,32,25,35,8,17,7,9,4,2,34,10,3])
adaptors = sorted(read_input())
# include start point (always 0) and goal (always max + 3)
adaptors = [0] + adaptors + [adaptors[-1] + 3]
print("goal", max(adaptors))

jump_list = {1: [], 2: [], 3: []}

def store_jump(value, jumpsize):
    global jump_list
    jump_list[jumpsize] += [value]

# count jumps of 1 and jumps of 3 in full adaptor chain
for i in range(len(adaptors) - 1):
    curr_val, next_val = adaptors[i], adaptors[i+1]
    gap_curr_to_next = next_val - curr_val
    if gap_curr_to_next <= 3:
        store_jump(curr_val, gap_curr_to_next)
    else:
        print("impossible!", curr_val, next_val)
        break

# part 1 - 1820
print("p1", len(jump_list[1]) * len(jump_list[3]))

# memoizer for get_valid_moves
valid_moves_hash = {}

# get valid elements 1, 2 or 3 units ahead of a number
def get_valid_moves(num):
    global valid_moves_hash, adaptors
    if num in valid_moves_hash:
        return valid_moves_hash[num]
    else:
        result = [num + d for d in [1,2,3] if num + d in adaptors]
        valid_moves_hash[num] = result
        return result

# convert integer values to empty tree nodes with those values
def new_nodes(values):
    return [{"adaptor": v, "children": []} for v in values]

# count different paths between 2 nodes by building exhaustive recursion tree
# @returns {Integer}
def count_paths(startval, endval):
    # trivial cases
    if startval == endval or startval + 1 == endval:
        return 1
    elif startval + 2 == endval:
        if startval + 1 in adaptors:
            return 2
        else:
            return 1

    # the jump must be 3 or more (could be e.g. sequence 4-5-6-7-8-9)
    root = new_nodes([startval])
    unseen = [root[0]]
    seen = []
    limit = 20000
    while len(unseen) and len(seen) < limit: # hard limit in case...
        # shift next unseen
        node, unseen = unseen[0], unseen[1:]
        # lookup moves
        moves = get_valid_moves(node["adaptor"])
        # set children
        node["children"] = new_nodes(moves)
        # enqueue
        unseen += node["children"]
        # count 1 node
        seen += [node["adaptor"]]

    # done building tree. endval seen how many times?
    path_count = len([z for z in seen if z == endval])
    print(startval, "to", endval, ":", path_count, "paths")
    return path_count

# traverse from 0 to goal, but only count different routes when a 3-jump is not enforced
three_jump_points = jump_list[3]

# measure widths of sections without a 3-jump
nontrivial_section_markers = [(0,3)] + [(three_jump_points[i]+3, three_jump_points[i+1]) for i in range(len(three_jump_points) - 1)]

nontrivial_section_sizes = [count_paths(*pair) for pair in nontrivial_section_markers]

product = 1
for size in nontrivial_section_sizes:
    product *= size

# total paths from 0 to goal is the product of all sections' path variants - 3454189699072
print("p2", product)
