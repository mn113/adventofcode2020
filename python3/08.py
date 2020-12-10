#! /usr/bin/env python3
# Find where an instruction loop begins

def runInstructions(change_instruction_index=None):
    visited = {}
    acc = 0
    with open('../inputs/input08.txt') as fp:
        lines = fp.readlines()
        l = len(lines)
        pointer = 0
        while pointer < l:
            line = lines[pointer]
            words = line.split()

            if pointer == change_instruction_index:
                if words[0] == 'jmp':
                    words[0] = 'nop'
                elif words[0] == 'nop':
                    words[0] = 'jmp'
                print("changed to", words[0], "at", pointer)

            visited[pointer] = True

            if words[0] == 'acc':
                acc += int(words[1])
                pointer += 1

            elif words[0] == 'jmp':
                skip = int(words[1])
                pointer += skip

            elif words[0] == 'nop':
                pointer += 1

            #print(pointer, words, acc)

            if pointer >= l:
                return('Terminated with acc: {}!'.format(acc))

            if pointer in visited:
                return 'Last acc before loop: {}'.format(acc)

# part 1
print(runInstructions())

# part 2
for chindex in range(641):
    print("try", chindex, runInstructions(chindex))
