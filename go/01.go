package main

import (
	"fmt"
	"io/ioutil"
	"sort"
	"strconv"
	"strings"
)

var year int
var input []int
var limit int

func main() {
	year = 2020 // fingers crossed...
	input = readInput()
	limit = len(input) - 1
	part1()
	part2()
}

func readInput() []int {
	out := make([]int, 0, limit)
	data, _ := ioutil.ReadFile("../inputs/input01.txt")
	lines := strings.Split(string(data), "\n")
	for _, line := range lines {
		num, _ := strconv.Atoi(line)
		if num < 2020 {
			out = append(out, num)
		}
	}
	sort.Ints(out)
	return out
}

func part1() {
	for i := 0; i < limit-1; i++ {
		for j := i + 1; j < limit; j++ {
			sum := input[i] + input[j]
			if sum > year {
				break
			} else if sum == year {
				fmt.Printf("P1: %d\n", input[i]*input[j])
				break
			}
		}
	}
}

func part2() {
	for i := 0; i < limit-2; i++ {
		for j := i + 1; j < limit-1; j++ {
			for k := j + 1; k < limit; k++ {
				sum := input[i] + input[j] + input[k]
				if sum > year {
					break
				} else if sum == year {
					fmt.Printf("P2: %d\n", input[i]*input[j]*input[k])
					break
				}
			}
		}
	}
}
