//
//  FrameTests.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/23/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import XCTest
import UIKit

class FrameTests: XCTestCase {

    var frame: Frame!
    
    // Square contour with each side having a length of 2.
    let squareContour = [TwoDimensionalPoint(x: 0, y: 0),
                         TwoDimensionalPoint(x: 0, y: 1),
                         TwoDimensionalPoint(x: 0, y: 2),
                         TwoDimensionalPoint(x: 1, y: 2),
                         TwoDimensionalPoint(x: 2, y: 2),
                         TwoDimensionalPoint(x: 2, y: 1),
                         TwoDimensionalPoint(x: 2, y: 0),
                         TwoDimensionalPoint(x: 1, y: 0)]
    // A contour with a jump. 3 length horizontal, 1 vertical, 3 horizontal again. Right, up, right.
    let jumpContour = [TwoDimensionalPoint(x: 0, y: 0),
                       TwoDimensionalPoint(x: 1, y: 0),
                       TwoDimensionalPoint(x: 2, y: 0),
                       TwoDimensionalPoint(x: 3, y: 0),
                       TwoDimensionalPoint(x: 3, y: 1),
                       TwoDimensionalPoint(x: 4, y: 1),
                       TwoDimensionalPoint(x: 5, y: 1),
                       TwoDimensionalPoint(x: 6, y: 1)]
    // A straight line contour from x-axis 0 to 3 which doubles back on itself and has the start-end gap in the middle.
    let doubleBackContour = [TwoDimensionalPoint(x: 2, y: 0),
                             TwoDimensionalPoint(x: 3, y: 0),
                             TwoDimensionalPoint(x: 0, y: 0),
                             TwoDimensionalPoint(x: 1, y: 0)]
    
    
    override func setUp() {
        let testBundle = NSBundle(forClass: self.dynamicType)
        let imagePath = testBundle.pathForResource("simple_hallway0", ofType: "png")
        let corridorUIImage = UIImage(contentsOfFile: imagePath!)
        frame = Frame(image: corridorUIImage!)
        super.setUp()
    }
    
    func testCanGetCanny() {
        XCTAssertTrue(frame.edgeImage == nil)
        frame.obtainCanny()
        XCTAssertTrue(frame.edgeImage != nil)
    }
    
    func testCanObtainContours() {
        // Need a canny image to get the contours.
        let testBundle = NSBundle(forClass: self.dynamicType)
        let cannyImagePath = testBundle.pathForResource("simple_hallway0_canny", ofType: "png")
        let cannyUIImage = UIImage(contentsOfFile: cannyImagePath!)
        frame.edgeImage = cannyUIImage
        
        XCTAssertTrue(frame.contours.isEmpty)
        frame.obtainContours()
        XCTAssertFalse(frame.contours.isEmpty)
    }
    
    func testCanGetLineSegmentsFromSquareContour() {
        let squareLineSegments = frame.attainLineSegmentsFromContour(squareContour)
        
        XCTAssertTrue(contains(squareLineSegments, TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 2, y: 0))))
        XCTAssertTrue(contains(squareLineSegments, TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 2, y: 2), end: TwoDimensionalPoint(x: 2, y: 0))))
        XCTAssertTrue(contains(squareLineSegments, TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 2), end: TwoDimensionalPoint(x: 2, y: 2))))
        XCTAssertTrue(contains(squareLineSegments, TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 0, y: 2))))
        XCTAssertEqual(squareLineSegments.count, 4)
    }
    
    func testCanGetLineSegmentsFromJumpContour() {
        let jumpLineSegments = frame.attainLineSegmentsFromContour(jumpContour)
        
        XCTAssertTrue(contains(jumpLineSegments, TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 3, y: 0))))
        XCTAssertTrue(contains(jumpLineSegments, TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 3, y: 0), end: TwoDimensionalPoint(x: 3, y: 1))))
        XCTAssertTrue(contains(jumpLineSegments, TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 3, y: 1), end: TwoDimensionalPoint(x: 6, y: 1))))
        XCTAssertEqual(jumpLineSegments.count, 3)
    }
    
    func testCanGetLineSegmentsFromDoubleBackContour() {
        let doubleBackLineSegments = frame.attainLineSegmentsFromContour(doubleBackContour)
        
        XCTAssertTrue(contains(doubleBackLineSegments, TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 3, y: 0))))
        XCTAssertEqual(doubleBackLineSegments.count, 1)
    }
    
    func testCanFilterLineSegmentsBySize() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 1, y: 0))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 1, y: 1))
        let lineSegment2 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 0, y: 2))
        let lineSegments = [lineSegment0, lineSegment1, lineSegment2]
        
        let filteredLineSegments0 = frame.filterLineSegments(lineSegments, byLength: 1.1)
        let filteredLineSegments1 = frame.filterLineSegments(lineSegments, byLength: 1.9)
        
        XCTAssertEqual(filteredLineSegments0.count, 2)
        XCTAssertEqual(filteredLineSegments1.count, 1)
    }
    
    func testCanGetLengthFilteredLineSegmentArrayFromContourArray() {
        let contours = [squareContour, jumpContour]
        
        frame.obtainLineSegmentsFromContours(contours, byLength: 2)
        
        XCTAssertEqual(frame.lineSegments.count, 6)
    }
    
    func testGenerationOfVanishingPointModels() {
        frame.lineSegments = [TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 1), end: TwoDimensionalPoint(x: 1, y: 1)),
                              TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 1, y: 0), end: TwoDimensionalPoint(x: 1, y: 1))]
        
        let models = frame.generateVanishingPointModels(numberOfModels: 5)
        
        XCTAssertEqual(models.count, 5)
        XCTAssertEqual(models[0], TwoDimensionalPoint(x: 1, y: 1))
    }
    
}