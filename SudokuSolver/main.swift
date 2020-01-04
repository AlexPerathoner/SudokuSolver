//
//  main.swift
//  SudokuSolver
//
//  Created by Alex Perathoner on 02/01/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Foundation



var matrix: Matrix<Int?> = Matrix(rows: 9, columns: 9,defaultValue:nil)

print("Insert path of file with sudoku to solve: ")
let path = readLine()


matrix = stringToTable(getFileContent(path: path ?? "/Users/alex/Desktop/sudoku3.txt")!)

print(tableToString(matrix))
print("Solving...")
var historyMoves = [(x: Int, y: Int, value: Int)]()
let methodStart = Date()
if(solve(m: &matrix, old: &historyMoves)) {
	print("Solved!")
	print(tableToString(matrix))
} else {
	print("No solutions found")
}

let methodFinish = Date()
let executionTime = methodFinish.timeIntervalSince(methodStart)
print("Execution time: \(executionTime)")
