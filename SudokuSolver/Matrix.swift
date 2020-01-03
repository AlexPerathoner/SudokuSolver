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

func getUnusedElements(_ m: Matrix<Int?>, inRow: Int) -> [Int] {
	let items = [1,2,3,4,5,6,7,8,9]
	let row = m.getRow(inRow)
	return (items - filterNil(row))
}
func getUnusedElements(_ m: Matrix<Int?>, inColumn: Int) -> [Int] {
	let items = [1,2,3,4,5,6,7,8,9]
	let column = m.getColumn(inColumn)
	return (items - filterNil(column))
}
func getUnusedElements(inChunk: Matrix<Int?>) -> [Int] {
	let items = [1,2,3,4,5,6,7,8,9]
	return (items - filterNil(inChunk.grid))
}


func getPossibleElements(_ m: Matrix<Int?>, inRow: Int, inColumn: Int) -> [Int]? {
	let setA = Set(getUnusedElements(m, inRow: inRow))
	let setB = Set(getUnusedElements(inChunk: m.getChunk(Int(inRow/3), Int(inColumn/3))))
	let setC = getUnusedElements(m, inColumn: inColumn)
//	print(setA)
//	print(setB)
//	print(setC)
	var intersection = setA.intersection(setC)
	intersection = intersection.intersection(setB)
//	print(intersection)
	return intersection.sorted()
}

func getPossibleElements(_ m: Matrix<Int?>) -> Matrix<[Int]> {
	var tempMatrix = Matrix<[Int]>(rows: 9, columns: 9, defaultValue: [])
	for i in 0..<9 {
		for j in 0..<9 {
			if(m[i, j] == nil) {
				//print("Searching possible ns for x:\(j) y:\(i)...")
				//print(getPossibleElements(m, inRow: 0, inColumn: 8))
				//print(m[i, j])
				//print("new item's: \(newItem)")
				tempMatrix[i, j] = getPossibleElements(m, inRow: i, inColumn: j) ?? []
			}
		}
	}
	return tempMatrix
}

func findBestCell(m: Matrix<[Int]>) -> (x:Int, y:Int, value:Int)? {
	var filterCounter = 1
	var d = [[Int]]()
	// FIXME: Caution! Only works if there is at least one certain cell
	
	
	while d.isEmpty && filterCounter < 9 {
		d = m.grid.filter({$0.count == filterCounter})
		filterCounter += 1
	}
	if d.isEmpty {
		return nil
	}
	let index = m.grid.firstIndex(of: d[0])!
	let x = (index)%9
	let y = Int(index/9)
	return (x, y, d[0][0])
}




//
//func toTuple(text: String) -> (Int, Int) {
//	let splitted = text.split(separator: " ")
//	return (Int(splitted[0]), Int(splitted[1]))
//}

