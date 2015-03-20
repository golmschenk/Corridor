//
//  LinearAlgebra.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/19/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

struct Column {
    let values: [Double]
    
    init(_ values: [Double]) {
        self.values = values
    }
    
    subscript(index: Int) -> Double {
        return values[index]
    }
}

struct Matrix {
    let columns: [Column]
    let height: Int
    let width: Int
    
    init(_ matrixValues: [[Double]], autoTranspose: Bool=true) {
        // "Transpose" the input array of arrays so that the indexing will be intuitive.
        var columnValues = [[Double]]()
        if autoTranspose {
            for index in 0..<matrixValues[0].count {
                columnValues.append(map(matrixValues) { $0[index] })
            }
        } else {
            columnValues = matrixValues
        }
        height = columnValues[0].count
        width = columnValues.count
        columns = map(columnValues) { Column($0) }
    }
    
    subscript(index: Int) -> Column {
        return columns[index]
    }
    
    func transpose() -> Matrix {
        let matrixValues = map(columns) { $0.values }
        var columnValues = [[Double]]()
        for index in 0..<matrixValues[0].count {
            columnValues.append(map(matrixValues) { $0[index] })
        }
        return Matrix(columnValues, autoTranspose: false)
    }
    
    var T: Matrix {
        get {
            return self.transpose()
        }
    }
    
    func determinant() -> Double {
        if self.height == 2 {
            return columns[0][0]*columns[1][1] - columns[1][0]*columns[0][1]
        } else {
            var determinant = 0.0
            for (index, value) in enumerate(columns[0].values) {
                let subMatrix = map(Array(columns[1..<columns.count])) { (column: Column) -> [Double] in
                    var values = column.values
                    values.removeAtIndex(index)
                    return values
                }
                let subDeterminant = Matrix(subMatrix, autoTranspose: false).determinant()
                let sign = index % 2 == 0 ? 1.0 : -1.0
                determinant += sign * value * subDeterminant
            }
            return determinant
        }
    }
}

infix operator • { associativity left precedence 160 }

func • (left: Matrix, right: Matrix) -> Matrix {
    var matrixValues = [[Double]]()
    for index0 in 0..<right.width {
        var matrixRow = [Double]()
        for index1 in 0..<left.height {
            var total = 0.0
            for index2 in 0..<right.height {
                total += left[index2][index1] * right[index0][index2]
            }
            matrixRow.append(total)
        }
        matrixValues.append(matrixRow)
    }
    return Matrix(matrixValues, autoTranspose: false)
}

infix operator × { associativity left precedence 160 }

func × (left: Matrix, right: Matrix) -> Matrix {
    return Matrix([[left[0][1]*right[0][2]-left[0][2]*right[0][1]],
                   [left[0][2]*right[0][0]-left[0][0]*right[0][2]],
                   [left[0][0]*right[0][1]-left[0][1]*right[0][0]]], autoTranspose: false)
}
