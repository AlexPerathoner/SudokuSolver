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
let defaultPath = "/Users/alex/Desktop/sudoku.txt"
if(path == "") {path = defaultPath}


matrix = stringToTable(getFileContent(path: path)!)

print(tableToString(matrix))
print("Solving...")
var historyMoves = [(x: Int, y: Int, value: Int)]()

let methodStart = Date()

var sol: Matrix<Int?> = matrix {
	didSet {
		print("Solved!")
		print(tableToString(sol))
		let methodFinish = Date()
		let executionTime = methodFinish.timeIntervalSince(methodStart)
		print("Execution time: \(executionTime)")
		exit(2)
	}
}

DispatchQueue.global(qos: .background).async {
	let solver = Solver(matrix, historyMoves)
	solver.start()
}

sleep(10)
print("No solutions found")
