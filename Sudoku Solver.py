import numpy
import math

Puzzle_File = open("Sudoku_Problem.txt", "r", encoding="utf-8")

Puzzle = numpy.zeros((9,9),dtype=int)

for i in range (9):
    for j in range (9):
        Puzzle[i,j] = Puzzle_File.read(2)
        j += 1
    i += 1
print (Puzzle[8,])
class Methods:
    def getBox(row,column):
        return math.ceil((row + 1)/3) + (column + 1)

