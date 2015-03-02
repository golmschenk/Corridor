//
//  GeometryTests.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/27/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import XCTest


class TwoDimensionalPointTests: XCTestCase {
    func testEquivalence() {
        let point0 = TwoDimensionalPoint(x: 1, y: 1)
        let point1 = TwoDimensionalPoint(x: 1, y: 1)
        let point2 = TwoDimensionalPoint(x: 1, y: 0)
        
        XCTAssertTrue(point0 == point1)
        XCTAssertFalse(point0 == point2)
    }
    
    func testDistanceToPoint() {
        let point0 = TwoDimensionalPoint(x: 0, y: 0)
        let point1 = TwoDimensionalPoint(x: 2, y: 2)
        
        let distance = point0.distanceToPoint(point1)
        XCTAssertEqualWithAccuracy(distance, 2*sqrt(2), DBL_EPSILON)
    }
    
    func testDistanceToLineOfLineSegment() {
        let lineSegment = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 2))
        let point = TwoDimensionalPoint(x: 0, y: 2)
        
        let distance = point.distanceToLine(lineSegment)
        XCTAssertEqualWithAccuracy(distance, sqrt(2), DBL_EPSILON)
    }
    
    func testAcceptanceForLineSegmentExtension() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 100, y: 0))
        let point0 = TwoDimensionalPoint(x: 200, y: 1)
        
        XCTAssertTrue(point0.canExtendLineSegment(lineSegment0, withDeviationToLengthRatio: 0.05))
        
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 1, y: 0))
        let point1 = TwoDimensionalPoint(x: 2, y: 1)
        
        XCTAssertFalse(point1.canExtendLineSegment(lineSegment1, withDeviationToLengthRatio: 0.05))
    }
}

class TwoDimensionalLineSegmentTests: XCTestCase {
    func testLength() {
        let lineSegment = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 2))
        
        XCTAssertEqualWithAccuracy(lineSegment.length, 2*sqrt(2), DBL_EPSILON)
    }
    
    func testEquivalence() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 2))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 2))
        let lineSegment2 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 3))
        
        XCTAssertTrue(lineSegment0 == lineSegment1)
        XCTAssertFalse(lineSegment0 == lineSegment2)
    }
    
    func testMergingInPoints() {
        var lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 2))
        let lineSegment0expected = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 2))
        let point0 = TwoDimensionalPoint(x: 1, y: 1)
        
        lineSegment0.mergeInPoint(point0)
        
        XCTAssertEqual(lineSegment0, lineSegment0expected, "Should not have merged in the point since it's between the end points.")
        
        var lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 2))
        let lineSegment1expected = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 3, y: 3))
        let point1 = TwoDimensionalPoint(x: 3, y: 3)
        
        lineSegment1.mergeInPoint(point1)
        
        XCTAssertEqual(lineSegment1, lineSegment1expected, "Should have merged in the point since it's beyond the end point.")
    }
    
    func testVectorComputedProperty() {
        let lineSegment = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 1, y: 1), end: TwoDimensionalPoint(x: 3, y: 3))
        let vector = TwoDimensionalVector(x: 2, y: 2)
        
        XCTAssertEqual(lineSegment.vector, vector)
    }
    
    func testAngleToLineSegment() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 0, y: 1))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 1, y: 1))
        
        XCTAssertEqualWithAccuracy(lineSegment0.angleToLineSegment(lineSegment1), π/4, DBL_EPSILON)
    }
}