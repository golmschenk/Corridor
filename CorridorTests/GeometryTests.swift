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
}