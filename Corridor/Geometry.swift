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
    
    func distanceToPoint(point: TwoDimensionalPoint) -> Double {
        let (x0, y0) = self.asTuple()
        let (x1, y1) = point.asTuple()
        return sqrt(Double(y1-y0)**2 + Double(x1-x0)**2)
    }
    
    func distanceToLine(lineSegment: TwoDimensionalLineSegment) -> Double {
        let (x0, y0) = self.asTuple()
        let (x1, y1) = lineSegment.start.asTuple()
        let (x2, y2) = lineSegment.end.asTuple()
        let numeratorPart1 = (y2-y1)*x0 - (x2-x1)*y0
        let numeratorPart2 = x2*y1 - y2*x1
        let numerator = Double(abs(numeratorPart1 + numeratorPart2))
        let denominator = lineSegment.start.distanceToPoint(lineSegment.end)
        return numerator / denominator
    }
}

func == (point1: TwoDimensionalPoint, point2: TwoDimensionalPoint) -> Bool {
    return (point1.x == point2.x) && (point1.y == point2.y)
}


struct TwoDimensionalLineSegment {
    var start: TwoDimensionalPoint
    var end: TwoDimensionalPoint
}


struct TwoDimensionalManhattanVanishingPointSet {
    let X: TwoDimensionalPoint
    let Y: TwoDimensionalPoint
    let Z: TwoDimensionalPoint
}