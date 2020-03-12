//
//  Solver.swift
//  SudokuSolver
//
//  Created by Alex Perathoner on 12/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Foundation

class Solver: Thread {
	
	var workingMatrix: Matrix<Int?>
	var moves: [(x: Int, y: Int, value: Int)]
	
	init(_ matrix: Matrix<Int?>, _ moves: [(x: Int, y: Int, value: Int)]) {
		workingMatrix = matrix
		self.moves = moves
	}
	
	
	override func main() {
		solve(workingMatrix, moves)
	}
	
	
	func solve(_ matrix: Matrix<Int?>, _ moves: [(x: Int, y: Int, value: Int)]) {
		let possElements = getPossibleElements(workingMatrix)
		if let reccom = findBestCellsValues(m: possElements) {
			for i in reccom.values {
				var mTemp = workingMatrix
				var oldTemp = moves
				let cell = (x: reccom.x, y: reccom.y, value: i)
				if(!moves.contains(where: {$0 == cell})) {
					oldTemp.append(cell)
					mTemp[reccom.y, reccom.x] = i
					
					if(!mTemp.hasNil()) {
						sol = mTemp
					}
					
					let solver = Solver(mTemp, oldTemp)
					solver.start()
					
				}
			}
		}
	}
	
	
	

	// MARK: - checks for matrix
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

	// MARK: - getter for unused numbers in row, column or chunk
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


	/// Returns all the possible items in a given coordinated
	/// - Parameters:
	///   - m: matrix to apply
	///   - inRow: y coordinate
	///   - inColumn: x coordinate
	/// - Returns:
	/// sorted array with the intersection of the sets (possible items according to row, column and chunk)
	func getPossibleElements(_ m: Matrix<Int?>, inRow: Int, inColumn: Int) -> [Int]? {
		let setA = Set(getUnusedElements(m, inRow: inRow))
		let setB = Set(getUnusedElements(inChunk: m.getChunk(Int(inRow/3), Int(inColumn/3))))
		let setC = getUnusedElements(m, inColumn: inColumn)
		var intersection = setA.intersection(setC)
		intersection = intersection.intersection(setB)
		return intersection.sorted()
	}

	/// Calculates for each cell of the matrix which numbers are possible
	/// - Parameter m: Input matrix
	/// - Returns: Ex: at m[0,0] is an array with all the possible numbers. If no numbers are possible [] is returned
	func getPossibleElements(_ m: Matrix<Int?>) -> Matrix<[Int]> {
		var tempMatrix = Matrix<[Int]>(rows: 9, columns: 9, defaultValue: [])
		for i in 0..<9 {
			for j in 0..<9 {
				if(m[i, j] == nil) {
					tempMatrix[i, j] = getPossibleElements(m, inRow: i, inColumn: j) ?? []
				}
			}
		}
		return tempMatrix
	}


	func findBestCellsValues(m: Matrix<[Int]>) -> (x:Int, y:Int, values:[Int])? {
		var d = [[Int]]()
		var filterCounter = 1
		while d.isEmpty && filterCounter < 9 {
			d = m.grid.filter({$0.count == filterCounter})
			filterCounter += 1
		}
		if d.isEmpty { //no possible moves
			return nil
		}
		let index = m.grid.firstIndex(of: d[0])!
		let x = (index)%9
		let y = Int(index/9)
		return (x, y, d[0])
	}

	func findTwinCell(m: Matrix<[Int]>, cell: (x:Int, y:Int, values:[Int]), value: Int) ->  (x:Int, y:Int, value:Int)? {
		if(cell.values.count != 2) {return nil}
		if let index = m.grid.lastIndex(of: cell.values) {
			let x = (index)%9
			let y = Int(index/9)
			
			if(x == cell.x && y == cell.y) {return nil}
			if(cell.values[0] == value) {
				return (x, y, cell.values[1])
			}
			return (x, y, cell.values[0])
		}
		return nil
	}
}
