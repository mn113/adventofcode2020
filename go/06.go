package main

import (
	"fmt"
	"io/ioutil"
	"regexp"
	"strings"
)

var groups []string

func main() {
	groups = readInput()
	part1()
	part2()
}

func readInput() []string {
	data, _ := ioutil.ReadFile("../inputs/input06.txt")
	return strings.Split(string(data), "\n\n")
}

// Transform slice of strings into slice of unique strings
func unique(strSlice []string) []string {
	keys := make(map[string]bool)
	list := []string{}
	for _, entry := range strSlice {
		if _, value := keys[entry]; !value {
			keys[entry] = true
			list = append(list, entry)
		}
	}
	return list
}

// Sum the number of distinct letters in each group
func part1() {
	count := 0
	for _, group := range groups {
		re := regexp.MustCompile(`[a-z]`)
		matches := re.FindAllString(group, -1)
		count += len(unique(matches))
	}
	fmt.Printf("P1: %d\n", count)
}

// Sum the number of distinct letters appearing in every line in a group
func part2() {
	count := 0
	for _, group := range groups {
		lines := strings.Split(group, "\n")
		goodchars := 0
		for c := 'a'; c <= 'z'; c++ {
			badlines := 0
			for _, line := range lines {
				if !strings.ContainsRune(line, c) {
					badlines++
				}
			}
			if badlines == 0 {
				goodchars++
			}
		}
		count += goodchars
	}
	fmt.Printf("P2: %d\n", count)
}
