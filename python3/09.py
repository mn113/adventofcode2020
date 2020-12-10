#! /usr/bin/env python3

def read_input():
    with open('../inputs/input09.txt') as fp:
        lines = fp.readlines()
        return [int(line) for line in lines]

chain = [35,20,15,25,47,40,62,55,65,95,102,117,150,182,127,219,299,277,309,576]
preamble = 5

chain = read_input()
preamble = 25

# Find number in chain which is not the sum of 2 within preceding N numbers
# part 1 - 29221323
for n in range(len(chain) - preamble):
    # print("index", n, ":", chain[n+5])
    offset_n = n + preamble
    found = False
    for i in range(0, preamble):
        a = chain[n+i]
        for j in range(1, preamble - i):
            b = chain[n+i+j]
            if a + b == chain[offset_n]:
                # print(a, "+", b, "=", chain[n], "at", n)
                found = True
    if not found:
        print(chain[offset_n], "has no pair")

# find min & max elems of a contiguous sequence which sums to 29221323
# @param {Number} goal
# @returns {List} subchain
def search_subchain(goal):
    min_subchain = 2
    max_subchain = 1000

    for size in range(min_subchain, max_subchain):
        total = sum(chain[:size])
        for n in range(len(chain) - size + 1):
            subchain = chain[n:n+size]
            if n > 0:
                # subtract previous, add next (to reduce duplicated summing)
                total = total - chain[n-1] + subchain[-1]
            if total == goal:
                print("FOUND", goal, subchain)
                return subchain

# part 2 - 4389369
subchain = search_subchain(29221323)
print((min(subchain) + max(subchain)))
