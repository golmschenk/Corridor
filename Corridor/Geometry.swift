//
//  VanishingPoints.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/19/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

struct TwoDimensionalPoint {
    let x: Int
    let y: Int
    
    func asTuple() -> (Int, Int) {
        return (x, y)
    }
}

func == (point1: TwoDimensionalPoint, point2: TwoDimensionalPoint) -> Bool {
    return (point1.x == point2.x) && (point1.y == point2.y)
}

struct TwoDimensionalManhattanVanishingPointSet {
    let X: TwoDimensionalPoint
    let Y: TwoDimensionalPoint
    let Z: TwoDimensionalPoint
}

struct TwoDimensionalLineSegment {
    var start: TwoDimensionalPoint
    var end: TwoDimensionalPoint
}