//
//  MathTests.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/27/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import XCTest


class MathTests: XCTestCase {
    
    func testInfixPower() {
        XCTAssertEqualWithAccuracy(3**3, 27, DBL_EPSILON)
        XCTAssertEqualWithAccuracy(3**0.2, 1.24573093961552, Double(FLT_EPSILON))
    }
    
    func testChoose2() {
        XCTAssertEqual(choose2(from: 5), 10)
        XCTAssertEqual(choose2(from: 30), 435)
    }
    
    func testDegreesFromRadians() {
        println(0.1 ≈≈ 0.2)
        XCTAssertTrue(degreesFromRadians(0.261799387799149) ≈≈ 15)
    }
    
    func testRadiansFromDegrees() {
        XCTAssertTrue(0.261799387799149 ≈≈ radiansFromDegrees(15))
    }
    
}