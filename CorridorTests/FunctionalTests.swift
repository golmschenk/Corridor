//
// Created by Greg Olmschenk on 1/30/15.
// Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import UIKit
import XCTest

class FunctionalTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
    * Tests that the user can select an image to load, have the algorithm process the image, and display the result.
    */
    func testUserCanLoadAndProcessImage() {
        let viewController = ViewController()

        // Check that the view loaded.
        XCTAssertNotNil(viewController.view, "View Did Not load")

        // Make sure the frame is originally nil
        XCTFail("Finish me!") // XCTAssertNil(viewController.frame)

        // Check that the user can load an image as a frame.

        // Check that the frame is processed.

        // Check that the processed frame image is displayed.
    }

}