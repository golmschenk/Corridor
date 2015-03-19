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
}
