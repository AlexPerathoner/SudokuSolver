//
//  main.swift
//  SudokuSolver
//
//  Created by Alex Perathoner on 02/01/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Foundation



var matrix: Matrix<Int?> = Matrix(rows: 9, columns: 9,defaultValue:nil)

/*
print("Please insert the values given. If you don't know a value insert \"-\" or just press enter")
for i in 0..<matrix.columns {
	for j in 0..<matrix.rows {
		clearScreen()
		print(tableToString())
		matrix[i, j] = input()
	}
	print("Now insert second row")
}
*/


matrix = stringToTable(getFileContent(path: "/Users/alex/Desktop/sudoku3.txt")!)

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
