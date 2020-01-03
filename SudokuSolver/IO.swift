//
//  IO.swift
//  SudokuSolver
//
//  Created by Alex Perathoner on 02/01/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Foundation

func input() -> Int? {
	return Int(readLine()!)
}

func tableToString(_ m: Matrix<Int?>) -> String {
	var str = ""
	for i in 0..<9 {
		for j in 0..<9 {
			if let a = m[i, j] {
				str += String(a)
			} else {
				str += "_"
			}
			if(j == 2 || j == 5) {str += " "}
		}
		if(i == 2 || i == 5) {str += "\n"}
		str += "\n"
	}
	return str
}

func stringToTable(_ text: String) -> Matrix<Int?> {
	var matrix: Matrix<Int?> = Matrix(rows: 9, columns: 9,defaultValue:nil)
	var i = 0
	text.enumerateLines { (line, stop) in
		var j = 0
		for character in line {
			matrix[i, j] = Int(String(character))
			j += 1
		}
		i += 1
	}
	return matrix
}


func clearScreen() {
	print("\u{001B}")
}
/*
func clearScreen() {
        let clearScreen = Process()
        clearScreen.launchPath = "/usr/bin/clear"
        clearScreen.arguments = []
        clearScreen.launch()
        clearScreen.waitUntilExit()
}*/

func getFileContent(path: String) -> String? {
	do {
		// Get the contents
		let contents = try String(contentsOfFile: path, encoding: .utf8)
		return contents
	}
	catch let error as NSError {
		print("Ooops! Something went wrong: \(error)")
	}
	return nil
}
