//
//  Performance_Tests.swift
//  Performance Tests
//
//  Created by Greg Olmschenk on 4/1/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import UIKit
import XCTest

class Performance_Tests: XCTestCase {
    
    func testBasicVanishingPointAttainingTime() {
        self.measureBlock() {
            let testBundle = NSBundle(forClass: self.dynamicType)
            let imagePath = testBundle.pathForResource("simple_hallway0", ofType: "png")
            let corridorUIImage = UIImage(contentsOfFile: imagePath!)
            let frame = Frame(image: corridorUIImage!)
            let vanishingPoints = frame.attainVanishingPoints()
        }
    }
    
}
