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
var path = readLine()!
let defaultPath = "/Users/alex/Desktop/sudoku3.txt"
if(path == "") {path = defaultPath}


matrix = stringToTable(getFileContent(path: path)!)

print(tableToString(matrix))
print("Solving...")
var historyMoves = [(x: Int, y: Int, value: Int)]()

/*
var combinations: CUnsignedLongLong = 1
for i in getPossibleElements(matrix).grid {
	if (i.count > 0)
	{
		combinations = combinations * UInt64(i.count)
		
	}
}
print("There are \(combinations) combinations in this sudoku!")
*/

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
