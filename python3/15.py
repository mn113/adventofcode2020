#! /usr/bin/env python3

starter = [None,5,1,9,18,13,8,0]

def say_until(limit):
    elvish = {0: []}
    n = None

    for i in range(1, limit + 1):
        # first few assignments
        if i < len(starter):
            n = starter[i]
            elvish[n] = [i]

        # unseen n: log under key 0
        elif n not in elvish:
            n = 0
            elvish[0].append(i)

        else:
            # work out new n
            if len(elvish[n]) == 1:
                n = 0
            else:
                n = elvish[n][-1] - elvish[n][-2]

            # log under key new n
            if n not in elvish:
                elvish[n] = [i]
            else:
                elvish[n].append(i)

    return n

print("p1", say_until(2020)) # 376
print("p2", say_until(30000000)) # 323780 (slow)
