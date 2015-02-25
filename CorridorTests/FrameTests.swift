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
    
    override func setUp() {
        let testBundle = NSBundle(forClass: self.dynamicType)
        let imagePath = testBundle.pathForResource("simple_hallway0", ofType: "png")
        let corridorUIImage = UIImage(contentsOfFile: imagePath!)
        frame = Frame(image: corridorUIImage!)
        super.setUp()
    }
    
    func testFrameCanGetCanny() {
        XCTAssertTrue(frame.edgeImage == nil)
        frame.obtainCanny()
        XCTAssertTrue(frame.edgeImage != nil)
    }
    
    func testFrameCanObtainContours() {
        // Need a canny image to get the contours.
        let testBundle = NSBundle(forClass: self.dynamicType)
        let cannyImagePath = testBundle.pathForResource("simple_hallway0_canny", ofType: "png")
        let cannyUIImage = UIImage(contentsOfFile: cannyImagePath!)
        frame.edgeImage = cannyUIImage
        
        XCTAssertTrue(frame.contours.isEmpty)
        frame.obtainContours()
        XCTAssertFalse(frame.contours.isEmpty)
    }
    
}