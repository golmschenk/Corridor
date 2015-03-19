//
//  LinearAlgebra.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/19/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

struct Matrix {

}

struct Column {
    let values: [Double]
    
    init(_ values: Double...) {
        self.values = values
    }
    
    subscript(index: Int) -> Double {
        return values[index]
    }
}