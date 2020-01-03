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


matrix = stringToTable(getFileContent(path: "/Users/alex/Desktop/sudoku2.txt")!)


print("Solving...")

print(tableToString(matrix))
while(matrix.hasNil()) {
	if let cell = findBestCell(m: getPossibleElements(matrix)) {
		matrix[cell.y, cell.x] = cell.value
		print("Added \(cell)")
	}
	clearScreen()
	print(tableToString(matrix))
}


//print(matrix)
