//
//  ImageProcessingTests.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/25/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import XCTest

class ImageProcessingTests: XCTestCase {
    
    func attainCameraMatrixForSimpleHallway1() -> Matrix {
        // Camera matrix for blender with F=35mm, W/w=0.00980392156mm/px, f=3570.00000314
        let K = Matrix([[3570.00000314,             0, 0],
                        [            0, 3570.00000314, 0],
                        [            0,             0, 1]])
        // Rotation of 10 degrees on y
        var R = Matrix([[ cos(radiansFromDegrees(10)), 0, sin(radiansFromDegrees(10))],
                        [                           0, 1,                           0],
                        [-sin(radiansFromDegrees(10)), 0, cos(radiansFromDegrees(10))]])
        // Camera offset by -0.5m in the x direction
        let T = Matrix([[-500],
                        [   0],
                        [   0]])
        
        var RT = R
        RT.addColumn(T.columns[0])
        RT.addRow([0, 0, 0, 1])
        var PwoK = RT.inverse()
        PwoK.removeRow(3)
        
        return K • PwoK
    }
    
    func attainCameraMatrixForSimpleHallway3() -> Matrix {
        // Camera matrix for blender with F=35mm, W/w=0.00980392156mm/px, f=3570.00000314
        let K = Matrix([[3570.00000314,             0, 0],
                        [            0, 3570.00000314, 0],
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
        
        return K • PwoK
    }
    
    func testZAxisVanishingPointFoundInSimpleHallway0() {
        // Create the frame from test file image.
        let testBundle = NSBundle(forClass: self.dynamicType)
        let imagePath = testBundle.pathForResource("simple_hallway0", ofType: "png")
        let corridorUIImage = UIImage(contentsOfFile: imagePath!)
        let frame = Frame(image: corridorUIImage!)
        
        let vanishingPoints = frame.attainVanishingPoints()
        println(vanishingPoints)
    }
}