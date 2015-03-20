//
//  Math.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/27/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import Darwin

let π = M_PI

infix operator ** { associativity left precedence 160 }

func ** (left: Double, right: Double) -> Double {
    return pow(left, right)
}

infix operator ≈≈ { precedence 130 }

func ≈≈ (left: Double, right: Double) -> Bool {
    return abs(left - right) < Constant.doubleEpsilon
}

//infix operator ≈≈ { precedence 130 }

func ≈≈ (matrix0: Matrix, matrix1: Matrix) -> Bool {
    if matrix0.height != matrix1.height || matrix0.width != matrix1.width {
        return false
    }
    for columnIndex in 0..<matrix0.columns.count {
        for valueIndex in 0..<matrix0[columnIndex].values.count {
            if abs(matrix0[columnIndex][valueIndex] - matrix1[columnIndex][valueIndex]) > Constant.doubleEpsilon {
                return false
            }
        }
    }
    return true
}

func choose2 (from n: Int) -> Int {
    return ((n-1)*(n))/2
}

func radiansFromDegrees (value:Double) -> Double {
    return value * π / 180.0
}

func degreesFromRadians (value:Double) -> Double {
    return value * 180.0 / π
}