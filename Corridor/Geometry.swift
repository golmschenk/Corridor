//
//  Geometry.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/19/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import Darwin

struct TwoDimensionalPoint: Equatable {
    let x: Int
    let y: Int
    
    var tuple: (Int, Int) {
        get {
            return (x, y)
        }
    }
    
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

func + (point1: TwoDimensionalPoint, point2: TwoDimensionalPoint) -> TwoDimensionalPoint {
    return TwoDimensionalPoint(x: point1.x + point2.x, y: point1.y + point2.y)
}

func / (point1: TwoDimensionalPoint, denominator: Int) -> TwoDimensionalPoint {
    return TwoDimensionalPoint(x: point1.x / denominator, y: point1.y / denominator)
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
        return (self.angleToLineSegment(lineSegment) % π) < angleAcceptance && (lineSegment.start.canExtendLineSegment(self, withDeviationToLengthRatio: deviationToLengthRatio) || lineSegment.end.canExtendLineSegment(self, withDeviationToLengthRatio: deviationToLengthRatio))
    }
    
    func findIntersectionWithLine(lineSegment: TwoDimensionalLineSegment) -> TwoDimensionalPoint? {
        let (x0, y0) = self.start.tuple
        let (x1, y1) = self.end.tuple
        let (x2, y2) = lineSegment.start.tuple
        let (x3, y3) = lineSegment.end.tuple
        
        let denominator = (x0-x1)*(y2-y3) - (y0-y1)*(x2-x3)
        if denominator == 0 {
            return nil
        }
        let xNumerator = (x0*y1-y0*x1)*(x2-x3)-(x0-x1)*(x2*y3-y2*x3)
        let yNumerator = (x0*y1-y0*x1)*(y2-y3)-(y0-y1)*(x2*y3-y2*x3)
        let x = xNumerator / denominator
        let y = yNumerator / denominator
        return TwoDimensionalPoint(x: x, y: y)
    }
    
    var midpoint: TwoDimensionalPoint {
        get {
            let (x0, y0) = self.start.tuple
            let (x1, y1) = self.end.tuple
            return TwoDimensionalPoint(x: (x0+x1)/2, y: (y0+y1)/2)
        }
    }
    
    func agreesWithVanishingPoint(point: TwoDimensionalPoint, withEndPointDeviationAcceptance endPointDeviationAcceptance: Double = Constant.endPointDeviationAcceptanceForLineSegmentToVanishingPointAgreement) -> Bool {
        let centerLine = TwoDimensionalLineSegment(start: self.midpoint, end: point)
        let deviationDistance = self.start.distanceToLine(centerLine)
        return endPointDeviationAcceptance >= deviationDistance / self.length
    }
    
    func attainSlopeAndIntercept() -> (slope: Double, intercept: Double) {
        let slope = Double(self.start.y - self.end.y) / Double(self.start.x - self.end.x)
        let intercept = Double(self.start.y) - (Double(self.start.x) * slope)
        return (slope, intercept)
    }
}

func == (lineSegment0: TwoDimensionalLineSegment, lineSegment1: TwoDimensionalLineSegment) -> Bool {
    return ((lineSegment0.start == lineSegment1.start) && (lineSegment0.end == lineSegment1.end)) || (lineSegment0.start == lineSegment1.end) && (lineSegment0.end == lineSegment1.start)
}

class TwoDimensionalPointCloud {
    var points = [TwoDimensionalPoint]()
    // Orthogonal regression line variables.
    var x̅ = 0.0
    var y̅ = 0.0
    var s_xx = 0.0
    var s_yy = 0.0
    var s_xy = 0.0
    var slope = 0.0
    var intercept = 0.0
    
    func obtainAverageX() {
        x̅ = points.reduce(0.0) { $0 + Double($1.x) } / Double(points.count)
    }
    
    func obtainAverageY() {
        y̅ = points.reduce(0.0) { $0 + Double($1.y) } / Double(points.count)
    }
    
    func obtainVarianceXx() {
        s_xx = points.reduce(0.0) { $0 + (Double($1.x) - x̅)**2 } / Double(points.count - 1)
    }
    
    func obtainVarianceYy() {
        s_yy = points.reduce(0.0) { $0 + (Double($1.y) - y̅)**2 } / Double(points.count - 1)
    }
    
    func obtainVarianceXy() {
        s_xy = points.reduce(0.0) { (Double($1.x) - x̅) * (Double($1.y) - y̅) + $0 } / Double(points.count - 1)
    }
    
    func obtainOrthogonalRegressionSlope() {
        slope = (s_yy - s_xx + sqrt((s_yy - s_xx)**2 + 4 * s_xy**2)) / (2 * s_xy)
    }
    
    func obtainOrthogonalRegressionIntercept() {
        intercept = y̅ - slope * x̅
    }
    
    func obtainOrthogonalRegressionLine() {
        obtainAverageX()
        obtainAverageY()
        obtainVarianceXx()
        obtainVarianceYy()
        obtainVarianceXy()
        obtainOrthogonalRegressionSlope()
        obtainOrthogonalRegressionIntercept()
    }
    
    /*func attainCorrespondingRegressionLinePointForPoint(point: TwoDimensionalPoint) -> (x: Double, y: Double) {
        // Get corresponding regression x.
        let x = point.x
    }*/
}


struct TwoDimensionalManhattanVanishingPointSet {
    let X: TwoDimensionalPoint
    let Y: TwoDimensionalPoint
    let Z: TwoDimensionalPoint
}