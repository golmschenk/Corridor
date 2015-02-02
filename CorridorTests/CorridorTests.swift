//
//  CorridorTests.swift
//  CorridorTests
//
//  Created by Greg Olmschenk on 1/29/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import UIKit
import XCTest

class CorridorTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testViewHasLoadImageButton() {
        let viewController = ViewController()
        XCTAssertTrue(viewController.respondsToSelector(Selector("loadImageButton")))
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        XCTAssert(true, "Pass")
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
