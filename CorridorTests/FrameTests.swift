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
    
    /*func testCanGetLineSegmentsFromContour() {
        let lineSegments = frame.attainLineSegmentsFromContour(squareContour)
        XCTAssertFalse(lineSegments.isEmpty)
    }*/
    
}