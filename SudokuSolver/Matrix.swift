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
	func getChunk(_ x: Int, _ y: Int) -> Matrix<Int?> {
		var matrix: Matrix<Int?> = Matrix<Int?>(rows: 3, columns: 3,defaultValue:nil)
		for i in 0..<3 {
			for j in 0..<3 {
				matrix[i, j] = self[i+x*3, j+y*3] as? Int
			}
		}
		return matrix
	}
}

extension Array {
	func chunked(into size: Int) -> [[Element]] {
		return stride(from: 0, to: count, by: size).map {
			Array(self[$0 ..< Swift.min($0 + size, count)])
		}
	}
}
extension Array where Element:Hashable {
	func getDuplicates() -> [Element] {
		//by Rob Caraway -> https://stackoverflow.com/questions/29727618/find-duplicate-elements-in-array-using-swift
		return [Element](Dictionary(grouping: self, by: {$0}).filter { $1.count > 1 }.keys)
	}
}

func hasMultipleItems(inRow: Int) -> Bool {
	let row = matrix.getRow(inRow)
	return !(filterNil(row)).getDuplicates().isEmpty
}
func hasMultipleItems(inColumn: Int) -> Bool {
	let column = matrix.getColumn(inColumn)
	return !(filterNil(column)).getDuplicates().isEmpty
}
func filterNil(_ input: [Int?]) -> [Int] {
	return input.compactMap { $0 }
}

func getUnusedElements(inRow: Int) -> [Int] {
	let items = [1,2,3,4,5,6,7,8,9]
	let row = matrix.getRow(inRow)
	return (items - filterNil(row))
}
func getUnusedElements(inColumn: Int) -> [Int] {
	let items = [1,2,3,4,5,6,7,8,9]
	let column = matrix.getColumn(inColumn)
	return (items - filterNil(column))
}
func getUnusedElements(inChunk: Matrix<Int?>) -> [Int] {
	let items = [1,2,3,4,5,6,7,8,9]
	return (items - filterNil(inChunk.grid))
}


func getPossibleElements(inRow: Int, inColumn: Int) -> [Int] {
	let setA = Set(getUnusedElements(inRow: inRow))
	let setB = Set(getUnusedElements(inChunk: matrix.getChunk(Int(inRow/3), Int(inColumn/3))))
	var intersection = setA.intersection(getUnusedElements(inColumn: inColumn))
	intersection = intersection.intersection(setB)
	return intersection.sorted()
}

func getPossibleElements() -> Matrix<[Int]> {
	var tempMatrix = Matrix<[Int]>(rows: 9, columns: 9, defaultValue: [])
	for i in 0..<8 {
		for j in 0..<8 {
			if(matrix[i, j] == nil) {
				tempMatrix[i, j] = getPossibleElements(inRow: i, inColumn: j)
			}
		}
	}
	return tempMatrix
}
