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

        // Kara opens the app and sees the main screen of the app.
        XCTAssertNotNil(viewController.view, "View Did Not load")

        // Originally, Kara sees that no image is selected.
        XCTAssertNil(viewController.frame)

        // She sees that there is a button to load an image.
        //XCTAssertNotNil(viewController.loadImageButton)

        // Once loaded, the main screen of the app shows the image.

        // Kara also sees there's a button to process the image.

        // After processing the image, Kara is shown the processed image which is nicely labelled.

        XCTFail("Finish me!")
    }

}