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
    
    func testAddition() {
        let point0 = TwoDimensionalPoint(x: 2, y: 2)
        let point1 = TwoDimensionalPoint(x: 3, y: 3)
        let point2 = TwoDimensionalPoint(x: 5, y: 5)
        
        XCTAssertEqual(point0 + point1, point2)
    }
    
    func testDivisionByInt() {
        let point0 = TwoDimensionalPoint(x: 6, y: 6)
        let point1 = TwoDimensionalPoint(x: 3, y: 3)
        let point2 = point0 / 2
        
        XCTAssertEqual(point1, point2)
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
    
    func testCanExtendLineSegment() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 0, y: 1))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 2), end: TwoDimensionalPoint(x: 0, y: 3))
        let lineSegment2 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 1, y: 0))
        let lineSegment3 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 2, y: 0), end: TwoDimensionalPoint(x: 3, y: 0))
        
        XCTAssertTrue(lineSegment0.canExtendLineSegment(lineSegment1, withAngleAcceptance: π/32, withDeviationToLengthRatio: 0.05))
        XCTAssertTrue(lineSegment2.canExtendLineSegment(lineSegment3, withAngleAcceptance: π/32, withDeviationToLengthRatio: 0.05))
    }
    
    func testCanExtendLineSegmentAcceptsLinesInOppositeDirections() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 0, y: 1))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 1), end: TwoDimensionalPoint(x: 0, y: 0))
        
        XCTAssertTrue(lineSegment0.canExtendLineSegment(lineSegment1, withAngleAcceptance: π/32, withDeviationToLengthRatio: 0.05))
    }
    
    func testCanExtendLineSegmentAngleAcceptance() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 0, y: 2))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 2), end: TwoDimensionalPoint(x: 1, y: 4))
        let lineSegment2 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 2), end: TwoDimensionalPoint(x: 3, y: 4))
        
        XCTAssertTrue(lineSegment0.canExtendLineSegment(lineSegment1, withAngleAcceptance: π/4, withDeviationToLengthRatio: 0.05))
        XCTAssertFalse(lineSegment0.canExtendLineSegment(lineSegment2, withAngleAcceptance: π/4, withDeviationToLengthRatio: 0.05))
    }
    
    func testCanExtendLineSegmentDeviationAcceptance() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 0, y: 1))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 1, y: 2), end: TwoDimensionalPoint(x: 1, y: 3))
        
        XCTAssertTrue(lineSegment0.canExtendLineSegment(lineSegment1, withAngleAcceptance: π/32, withDeviationToLengthRatio: 1.1))
        XCTAssertFalse(lineSegment0.canExtendLineSegment(lineSegment1, withAngleAcceptance: π/32, withDeviationToLengthRatio: 0.9))
    }
    
    func testMergingWithLineSegments() {
        var lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 2))
        var lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 4, y: 4))
        let lineSegmentToMerge = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 1, y: 1), end: TwoDimensionalPoint(x: 3, y: 3))
        let lineSegment0Expected = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 3, y: 3))
        let lineSegment1Expected = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 4, y: 4))
        
        lineSegment0.mergeWithLineSegment(lineSegmentToMerge)
        lineSegment1.mergeWithLineSegment(lineSegmentToMerge)
        
        XCTAssertEqual(lineSegment0, lineSegment0Expected)
        XCTAssertEqual(lineSegment1, lineSegment1Expected)
    }
    
    func testCanFindIntersectionWithLineSegment() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 1, y: 1), end: TwoDimensionalPoint(x: 2, y: 2))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: -1, y: 1), end: TwoDimensionalPoint(x: -2, y: 2))
        let point1 = TwoDimensionalPoint(x: 0, y: 0)
        
        let lineSegment2 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 2), end: TwoDimensionalPoint(x: 1, y: 2))
        let lineSegment3 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 2, y: 0), end: TwoDimensionalPoint(x: 2, y: 1))
        let point2 = TwoDimensionalPoint(x: 2, y: 2)
        
        XCTAssertEqual(lineSegment0.findIntersectionWithLine(lineSegment1)!, point1)
        XCTAssertEqual(lineSegment2.findIntersectionWithLine(lineSegment3)!, point2)
    }
    
    func testFindIntersectionWithParallelLinesReturnsNil() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 1, y: 0))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 1), end: TwoDimensionalPoint(x: 1, y: 1))
        XCTAssertTrue(lineSegment0.findIntersectionWithLine(lineSegment1) == nil)
    }
    
    func testMidpoint() {
        let lineSegment = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 0))
        let point = TwoDimensionalPoint(x: 1, y: 0)
        
        XCTAssertEqual(lineSegment.midpoint, point)
    }
    
    func testVanishingPointAgreement() {
        let lineSegment = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 2))
        let point1 = TwoDimensionalPoint(x: 6, y: 6)
        let point2 = TwoDimensionalPoint(x: 6, y: 0)
        
        XCTAssertTrue(lineSegment.agreesWithVanishingPoint(point1, withEndPointDeviationAcceptance: 0.05))
        XCTAssertFalse(lineSegment.agreesWithVanishingPoint(point2, withEndPointDeviationAcceptance: 0.05))
    }
    
    func testVanishingPointAgreementDeviationAcceptanceInput() {
        let lineSegment = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 2))
        let point = TwoDimensionalPoint(x: 6, y: 5)
        
        XCTAssertTrue(lineSegment.agreesWithVanishingPoint(point, withEndPointDeviationAcceptance: 0.20))
        XCTAssertFalse(lineSegment.agreesWithVanishingPoint(point, withEndPointDeviationAcceptance: 0.02))
    }
    
    func testAttainSlopeAndIntercept() {
        let lineSegment = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: -1, y: 6), end: TwoDimensionalPoint(x: 5, y: -4))
        let expectedSlope = -5.0/3.0
        let expectedIntercept = 13.0/3.0
        
        let (slope, intercept) = lineSegment.attainSlopeAndIntercept()
        
        XCTAssertEqual(slope, expectedSlope)
        XCTAssertEqual(intercept, expectedIntercept)
    }
    
}


class TwoDimensionalPointCloudTests: XCTestCase {
    func testAverageX() {
        var pointCloud = TwoDimensionalPointCloud()
        pointCloud.points = [TwoDimensionalPoint(x: 1, y: 4), TwoDimensionalPoint(x: 2, y: 3), TwoDimensionalPoint(x: 3, y: 2)]
        
        pointCloud.obtainAverageX()
        
        XCTAssertEqual(pointCloud.x̅, 2.0)
    }
    
    func testAverageY() {
        var pointCloud = TwoDimensionalPointCloud()
        pointCloud.points = [TwoDimensionalPoint(x: 1, y: 4), TwoDimensionalPoint(x: 2, y: 3), TwoDimensionalPoint(x: 3, y: 2)]
        
        pointCloud.obtainAverageY()

        XCTAssertEqual(pointCloud.y̅, 3.0)
    }
    
    func testVarianceXx() {
        var pointCloud = TwoDimensionalPointCloud()
        pointCloud.points = [TwoDimensionalPoint(x: 1, y: 4), TwoDimensionalPoint(x: 2, y: 3), TwoDimensionalPoint(x: 3, y: 2)]
        
        pointCloud.obtainAverageX()
        pointCloud.obtainVarianceXx()

        XCTAssertEqual(pointCloud.s_xx, 1.0)
    }
    
    func testVarianceYy() {
        var pointCloud = TwoDimensionalPointCloud()
        pointCloud.points = [TwoDimensionalPoint(x: 1, y: 4), TwoDimensionalPoint(x: 2, y: 3), TwoDimensionalPoint(x: 3, y: 2)]
        
        pointCloud.obtainAverageY()
        pointCloud.obtainVarianceYy()

        XCTAssertEqual(pointCloud.s_yy, 1.0)
    }
    
    func testVarianceXy() {
        var pointCloud = TwoDimensionalPointCloud()
        pointCloud.points = [TwoDimensionalPoint(x: 1, y: 4), TwoDimensionalPoint(x: 2, y: 3), TwoDimensionalPoint(x: 3, y: 2)]
        
        pointCloud.obtainAverageX()
        pointCloud.obtainAverageY()
        pointCloud.obtainVarianceXy()

        XCTAssertEqual(pointCloud.s_xy, -1.0)
    }
    
    func testOrthogonalRegressionSlope() {
        var pointCloud = TwoDimensionalPointCloud()
        pointCloud.points = [TwoDimensionalPoint(x: 1, y: 4), TwoDimensionalPoint(x: 2, y: 3), TwoDimensionalPoint(x: 3, y: 2)]
        
        pointCloud.obtainAverageX()
        pointCloud.obtainAverageY()
        pointCloud.obtainVarianceXx()
        pointCloud.obtainVarianceYy()
        pointCloud.obtainVarianceXy()
        pointCloud.obtainOrthogonalRegressionSlope()
        
        XCTAssertEqual(pointCloud.slope, -1.0)
    }
    
    func testOrthogonalRegressionIntercept() {
        var pointCloud = TwoDimensionalPointCloud()
        pointCloud.points = [TwoDimensionalPoint(x: 1, y: 4), TwoDimensionalPoint(x: 2, y: 3), TwoDimensionalPoint(x: 3, y: 2)]
        
        pointCloud.obtainAverageX()
        pointCloud.obtainAverageY()
        pointCloud.obtainVarianceXx()
        pointCloud.obtainVarianceYy()
        pointCloud.obtainVarianceXy()
        pointCloud.obtainOrthogonalRegressionSlope()
        pointCloud.obtainOrthogonalRegressionIntercept()
        
        XCTAssertEqual(pointCloud.intercept, 5.0)
    }
    
    func testOrthogonalRegressionLine() {
        var pointCloud0 = TwoDimensionalPointCloud()
        pointCloud0.points = [TwoDimensionalPoint(x: 1, y: 4), TwoDimensionalPoint(x: 2, y: 3), TwoDimensionalPoint(x: 3, y: 2)]
        var pointCloud1 = TwoDimensionalPointCloud()
        pointCloud1.points = [TwoDimensionalPoint(x: 10, y: -10), TwoDimensionalPoint(x: -10, y: 10), TwoDimensionalPoint(x: 1, y: 1), TwoDimensionalPoint(x: -1, y: -1)]
        
        pointCloud0.obtainOrthogonalRegressionLine()
        pointCloud1.obtainOrthogonalRegressionLine()
        
        XCTAssertEqual(pointCloud0.slope, -1.0)
        XCTAssertEqual(pointCloud0.intercept, 5.0)
        XCTAssertEqual(pointCloud1.slope, -1.0)
        XCTAssertEqual(pointCloud1.intercept, 0.0)
    }
}
