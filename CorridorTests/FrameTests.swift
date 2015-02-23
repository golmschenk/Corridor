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
        XCTAssertTrue(frame.edgeMap == nil)
        frame.canny()
        XCTAssertTrue(frame.edgeMap != nil)
    }
    
}