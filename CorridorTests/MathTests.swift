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
}