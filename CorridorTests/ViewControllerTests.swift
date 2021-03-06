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

    var viewController: ViewController!
    
    override func setUp() {
        viewController = ViewController()
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testViewHasLoadImageButton() {
        XCTAssertTrue(viewController.respondsToSelector(Selector("loadImageButton")))
    }
    
    func testLoadImageButtonOpensImagePicker() {
        viewController.loadImageButton()
        
        XCTAssertTrue(viewController.imagePicker.isViewLoaded())
    }
    
    func testImagePickerSetsFrameOnImageSelection() {
        let testBundle = NSBundle(forClass: self.dynamicType)
        let imagePath = testBundle.pathForResource("simple_hallway0", ofType: "png")
        let corridorUIImage = UIImage(contentsOfFile: imagePath!)
        
        viewController.imagePickerController(UIImagePickerController(), didFinishPickingImage: corridorUIImage, editingInfo: [:])
        
        XCTAssertNotNil(viewController.frame!.image)
        XCTAssertTrue(viewController.frame!.image.isEqual(corridorUIImage!), "The frame UIImage is not the same as the example UIImage")
    }
    
    func testViewHasProcessFrameButton() {
        XCTAssertTrue(viewController.respondsToSelector(Selector("processFrameButton")))
    }
    
}
