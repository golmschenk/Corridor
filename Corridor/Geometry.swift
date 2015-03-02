//
//  VanishingPoints.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/19/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import Darwin

struct TwoDimensionalPoint: Equatable {
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
        let denominator = lineSegment.length
        return numerator / denominator
    }
    
    func canExtendLineSegment(lineSegment: TwoDimensionalLineSegment, withDeviationToLengthRatio deviationToLengthRatio: Double = Constant.lineSegmentLengthToPointDeviationRatioForExtensionAcceptanceOfLineSegmentByPoint) -> Bool {
        let deviation = self.distanceToLine(lineSegment)
        let length = lineSegment.length
        return deviation/length < deviationToLengthRatio
    }
}

func == (point1: TwoDimensionalPoint, point2: TwoDimensionalPoint) -> Bool {
    return (point1.x == point2.x) && (point1.y == point2.y)
}

typealias TwoDimensionalVector = TwoDimensionalPoint

struct TwoDimensionalLineSegment: Equatable {
    var start: TwoDimensionalPoint
    var end: TwoDimensionalPoint
    
    var length: Double {
        get {
            return self.start.distanceToPoint(self.end)
        }
    }
    
    var vector: TwoDimensionalVector {
        get {
            return TwoDimensionalVector(x: self.end.x - self.start.x, y: self.end.y - self.start.y)
        }
    }
    
    mutating func mergeInPoint(point: TwoDimensionalPoint) {
        // Find which end point the new point is closest to.
        let endIsCloser = point.distanceToPoint(self.end) < point.distanceToPoint(self.start)
        let (closerPoint, fartherPoint) = endIsCloser ? (self.end, self.start) : (self.start, self.end)
        // See if the new point is beyond the line segment ends.
        if fartherPoint.distanceToPoint(closerPoint) < fartherPoint.distanceToPoint(point) {
            // Update the line segment.
            if endIsCloser {
                self.end = point
            }
            else {
                self.start = point
            }
        }
    }
    
    mutating func mergeWithLineSegment(lineSegment: TwoDimensionalLineSegment) {
        self.mergeInPoint(lineSegment.start)
        self.mergeInPoint(lineSegment.end)
    }
    
    func angleToLineSegment(lineSegment: TwoDimensionalLineSegment) -> Double {
        return acos(Double(self.vector.x * lineSegment.vector.x + self.vector.y * lineSegment.vector.y) / ( self.length * lineSegment.length))
    }
    
    // Could consider making the acceptance values depend on segment lengths.
    func canExtendLineSegment(lineSegment: TwoDimensionalLineSegment, withAngleAcceptance angleAcceptance: Double = Constant.angleAcceptanceForExtensionAcceptanceOfLineSegmentWithLineSegment, withDeviationToLengthRatio deviationToLengthRatio: Double = Constant.lineSegmentLengthToPointDeviationRatioForExtensionAcceptanceOfLineSegmentByPoint) -> Bool {
        return self.angleToLineSegment(lineSegment) < angleAcceptance && (lineSegment.start.canExtendLineSegment(self, withDeviationToLengthRatio: deviationToLengthRatio) || lineSegment.end.canExtendLineSegment(self, withDeviationToLengthRatio: deviationToLengthRatio))
    }
}

func == (lineSegment0: TwoDimensionalLineSegment, lineSegment1: TwoDimensionalLineSegment) -> Bool {
    return (lineSegment0.start == lineSegment1.start) && (lineSegment0.end == lineSegment1.end)
}


struct TwoDimensionalManhattanVanishingPointSet {
    let X: TwoDimensionalPoint
    let Y: TwoDimensionalPoint
    let Z: TwoDimensionalPoint
}