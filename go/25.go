package main

import (
	"fmt"
)

func transform(subjnum uint64, loopsize uint64) uint64 {
	val := uint64(1)
	for i := uint64(0); i < loopsize; i++ {
		val *= subjnum
		val %= 20201227
	}
	return val
}

func main() {
	card_pubkey := uint64(9033205)
	door_pubkey := uint64(9281649)
	card_loopsize := uint64(0)

	val := uint64(1)
	subjnum := uint64(7)
	for cls := uint64(1); cls < 20000000; cls++ {
		val *= subjnum
		val %= 20201227

		if val == card_pubkey {
			card_loopsize = cls
			fmt.Printf("cls = %d\n", card_loopsize)
		}
	}

	// part 1 - 9714832
	encryption_key := transform(door_pubkey, card_loopsize)
	fmt.Println("p1", encryption_key)
}
