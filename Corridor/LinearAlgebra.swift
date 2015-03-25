//
//  LinearAlgebra.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/19/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

class Column {
    var values: [Double]
    
    init(_ values: [Double]) {
        self.values = values
    }
    
    subscript(index: Int) -> Double {
        return values[index]
    }
}

class Matrix : Equatable {
    var columns: [Column]
    var height = 0
    var width = 0
    
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
        columns = map(columnValues) { Column($0) }
        updateSize()
    }
    
    func updateSize() {
        height = self.columns[0].values.count
        width = self.columns.count
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
            let a = columns[0][0]
            let b = columns[1][0]
            let c = columns[0][1]
            let d = columns[1][1]
            return a*d - b*c
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
    
    func inverse() -> Matrix {
        if self.height == 2 {
            return self.determinant() * Matrix([[self[1][1], -self[1][0]], [-self[0][1], self[0][0]]], autoTranspose: false)
        } else {
            var minorMatrixValues = [[Double]]()
            for index0 in 0..<self.height {
                var minorMatrixColumn = [Double]()
                for index1 in 0..<self.width {
                    var subColumns = columns
                    subColumns.removeAtIndex(index0)
                    let subMatrix = map(subColumns) { (column: Column) -> [Double] in
                        var values = column.values
                        values.removeAtIndex(index1)
                        return values
                    }
                    let sign = (index0 + index1) % 2 == 0 ? 1.0 : -1.0
                    minorMatrixColumn.append(sign * Matrix(subMatrix).determinant())
                }
                minorMatrixValues.append(minorMatrixColumn)
            }
            return (1.0/self.determinant()) * Matrix(minorMatrixValues, autoTranspose: false).transpose()
        }
    }
    
    func addColumn(column: Column) {
        columns.append(column)
        updateSize()
    }
    
    func removeColumn(columnIndex: Int) {
        columns.removeAtIndex(columnIndex)
        updateSize()
    }
    
    func addRow(row: [Double]) {
        map(enumerate(columns)) { $1.values.append(row[$0]) }
        updateSize()
    }
    
    func removeRow(rowIndex: Int) {
        map(columns) { $0.values.removeAtIndex(rowIndex) }
        updateSize()
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

func == (matrix0: Matrix, matrix1: Matrix) -> Bool {
    if matrix0.height != matrix1.height || matrix0.width != matrix1.width {
        return false
    }
    for columnIndex in 0..<matrix0.columns.count {
        for valueIndex in 0..<matrix0[columnIndex].values.count {
            if matrix0[columnIndex][valueIndex] != matrix1[columnIndex][valueIndex] {
                return false
            }
        }
    }
    return true
}

func * (scalar: Double, matrix: Matrix) -> Matrix {
    let matrixValues = map(matrix.columns) { map($0.values) { $0 * scalar } }
    return Matrix(matrixValues, autoTranspose: false)
}

