package main

import (
	"bufio"
	"fmt"
	"os"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

const FILE_PATH = "./examples/mandelbrot.bf"

var data [30000]byte
var curr int

func main() {
	fileContents, err := os.ReadFile(FILE_PATH)
	check(err)

	for i := 0; i < len(fileContents); i++ {
		switch fileContents[i] {
		case '<':
			curr--
		case '>':
			curr++

		case '+':
			data[curr]++
		case '-':
			data[curr]--

		case ',':
			reader := bufio.NewReader(os.Stdin)
			input, err := reader.ReadByte()
			check(err)
			data[curr] = input
		case '.':
			fmt.Printf("%c", data[curr])

		case '[':
			if data[curr] == 0 {
				jump(Forward, &i, fileContents)
			}
		case ']':
			if data[curr] != 0 {
				jump(Backward, &i, fileContents)
			}
		}
	}

	return
}

type Direction = int

const (
	Forward  Direction = 1
	Backward Direction = -1
)

func jump(direction Direction, i *int, fileContents []byte) {
	var bracketCount int = 1

	for bracketCount != 0 {
		*i += direction

		switch fileContents[*i] {
		case '[':
			bracketCount += direction
		case ']':
			bracketCount -= direction
		}
	}
}
