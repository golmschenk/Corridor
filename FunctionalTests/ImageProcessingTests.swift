//
//  ImageProcessingTests.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/25/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import XCTest

class ImageProcessingTests: XCTestCase {
    
    var P: Matrix
    
    func obtainCameraMatrixForSimpleHallway3() {
        // Camera matrix for blender with f=35mm, F=0.00980392156mm/px
        let K = Matrix([[0.00980392156,             0, 0],
            [            0, 0.00980392156, 0],
            [            0,             0, 1]])
        // Rotation of -10 degrees on x then -10 degrees on y
        let R = Matrix([[0.98480775, -0.03015369, -0.17101007],
            [         0,  0.98480775, -0.17364818],
            [0.17364818,  0.17101007,  0.96984631]])
        // Camera offset by 0.5m in both the x and y directions
        let T = Matrix([[500],
            [500],
            [  0]])
        
        var RT = R
        RT.addColumn(T.columns[0])
        RT.addRow([0, 0, 0, 1])
        var PwoK = RT.inverse()
        PwoK.removeRow(3)
        
        P = K • PwoK
    }
    
    func testCameraTransformation() {
        obtainCameraMatrixForSimpleHallway3()
        point0 = Matrix([[0], [0], [50]])
    }
}