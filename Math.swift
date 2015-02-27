//
//  Math.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/27/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

infix operator ** { associativity left precedence 160 }

func ** (left: Double, right: Double) -> Double {
    return pow(left, right)
}