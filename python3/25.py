#! /usr/bin/env python3

card_pubkey = 9033205
door_pubkey = 9281649

card_loopsize = 0

def transform(subjnum, loopsize):
    val = 1
    for i in range(loopsize):
        val *= subjnum
        val %= 20201227
    print(loopsize)
    return val

# find card_loopsize: transform 7 until card_pubkey achieved
val = 1
subjnum = 7
for ls in range(1,20000000):
    val *= subjnum
    val %= 20201227

    if val == card_pubkey:
        card_loopsize = ls
        print('cls =', card_loopsize)
        break
else:
    print('NF')

# part 1 - 9714832
encryption_key = transform(door_pubkey, card_loopsize)
print('p1', encryption_key)
print(transform(1,3))
