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
    
    /*func testDistanceBetweenTwoPoints() {
        let point0 = TwoDimensionalPoint(x: 1, y: 1)
        let point1 = TwoDimensionalPoint(x: 1, y: 1)
        
        let distance = point0.distanceToPoint(point1)
        XCTAssertEqualWithAccuracy(distance, 2*sqrt(2), FLT_EPSILON)
    }*/
}