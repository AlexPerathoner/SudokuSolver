//
//  Matrix.swift
//  SudokuSolver
//
//  Created by Alex Perathoner on 02/01/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Foundation

func -<T: RangeReplaceableCollection>(lhs: T, rhs: T) -> T where T.Iterator.Element: Equatable {
    var lhs = lhs
    for element in rhs {
        if let index = lhs.firstIndex(of: element) { lhs.remove(at: index) }
    }
    return lhs
}

struct Matrix<T> {
	let rows: Int, columns: Int
	var grid: [T]
	init(rows: Int, columns: Int, defaultValue: T) {
		self.rows = rows
		self.columns = columns
				grid = Array(repeating: defaultValue, count: rows * columns)
	}
	func indexIsValid(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	subscript(row: Int, column: Int) -> T {
		get {
			let safeRow = 0 ... rows-1 ~= row ? row : row > rows-1 ? 0 : row < 0 ? rows-1 : -1
			let safeColumn = 0 ... columns-1 ~= column ? column : column > columns-1 ? 0 : column < 0 ? columns-1 : -1
			assert(indexIsValid(row: safeRow, column: safeColumn), "Index out of range")
			return grid[(safeRow * columns) + safeColumn]
		}
		set {
			assert(indexIsValid(row: row, column: column), "Index out of range")
					grid[(row * columns) + column] = newValue
		}
	}
}

extension Matrix {
	func getRow(_ row: Int) -> [T] {
		return grid.chunked(into: 9)[row]
	}
	func getColumn(_ column: Int) -> [T] {
		let tempGrid = grid.chunked(into: 9)
		var columnToReturn = [T]()
		for element in tempGrid {
			columnToReturn.append(element[column])
		}
		return columnToReturn
	}
	/// Returns a 3x3 matrix relative to one of the 9 chunks in the sudoku
	/// - Parameters:
	///   - x: x coordinate of the chunk
	///   - y: y coordinate of the chunk
	/// - Returns:
	///	  - 3x3 matrix
	func getChunk(_ x: Int, _ y: Int) -> Matrix<Int?> {
		var matrix: Matrix<Int?> = Matrix<Int?>(rows: 3, columns: 3,defaultValue:nil)
		for i in 0..<3 {
			for j in 0..<3 {
				matrix[i, j] = self[i+x*3, j+y*3] as? Int
			}
		}
		return matrix
	}
	
	/// - Returns:
	/// true if the matrix contains nil values
	func hasNil() -> Bool {
		for i in grid {
			if((i as? Int) == nil) {
				return true
			}
		}
		return false
	}
}

extension Array {
	/// by Paul Hudson -> https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
	/// - Parameter size: length of each sub array
	func chunked(into size: Int) -> [[Element]] {
		return stride(from: 0, to: count, by: size).map {
			Array(self[$0 ..< Swift.min($0 + size, count)])
		}
	}
}
extension Array where Element:Hashable {
	/// by Rob Caraway -> https://stackoverflow.com/questions/29727618/find-duplicate-elements-in-array-using-swift
	/// - Returns:
	///   - Array with elements that appeared more than once in the given array
	func getDuplicates() -> [Element] {
		return [Element](Dictionary(grouping: self, by: {$0}).filter { $1.count > 1 }.keys)
	}
}


