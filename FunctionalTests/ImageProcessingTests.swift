//
//  ImageProcessingTests.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/25/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import XCTest
import CoreGraphics

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
    
    func testManhattanDirectionVanishingPointsAreFoundInSimpleHallway0() {
        // Create the frame from test file image.
        let testBundle = NSBundle(forClass: self.dynamicType)
        let imagePath = testBundle.pathForResource("simple_hallway0", ofType: "png")
        let corridorUIImage = UIImage(contentsOfFile: imagePath!)
        let frame = Frame(image: corridorUIImage!)
        let center = (x: 612, y: 816)
        
        let vanishingPoints = frame.attainVanishingPoints()
        
        // Check that the Z axis vanishing point was found. Must be a point close to the center.
        let zAxisQualifying = vanishingPoints.filter() { abs($0.x - center.x) < 15 && abs($0.y - center.y) < 15 }
        XCTAssertTrue(zAxisQualifying.count >= 1)
        // Check that the X axis vanishing point was found. Must have a huge ratio between the x and the y from the center.
        let xAxisQualifying = vanishingPoints.filter() {
            let xDiff = abs($0.x - center.x)
            let yDiff = abs($0.y - center.y)
            let hasLargeRatio = $0.y - center.y == 0 || xDiff / yDiff > 300
            let hasDistantPoint = xDiff > 2000
            return hasLargeRatio && hasDistantPoint
        }
        XCTAssertTrue(xAxisQualifying.count >= 1)
        // Check that the Y axis vanishing point was found. Must have a huge ratio between the y and the x from the center.
        let yAxisQualifying = vanishingPoints.filter() {
            let xDiff = abs($0.x - center.x)
            let yDiff = abs($0.y - center.y)
            let hasLargeRatio = $0.x - center.x == 0 || yDiff / xDiff > 300
            let hasDistantPoint = yDiff > 2000
            return hasLargeRatio && hasDistantPoint
        }
        XCTAssertTrue(yAxisQualifying.count >= 1)
    }
    
    func testManhattanDirectionVanishingPointsAreFoundInSimpleHallway3() {
        // Create the frame from test file image.
        let testBundle = NSBundle(forClass: self.dynamicType)
        let imagePath = testBundle.pathForResource("simple_hallway3", ofType: "png")
        let corridorUIImage = UIImage(contentsOfFile: imagePath!)
        let frame = Frame(image: corridorUIImage!)
        let center = (x: 612, y: 816)
        
        let vanishingPoints = frame.attainVanishingPoints()
        
        //Debug
        let image = frame.attainDebugAnnotatedImage(["contours"])
        let edgeimage = frame.edgeImage!
        
        // Check that the Z axis vanishing point was found. Must be a point close to the center.
        let zAxisQualifying = vanishingPoints.filter() { abs($0.x - center.x) < 15 && abs($0.y - center.y) < 15 }
        XCTAssertTrue(zAxisQualifying.count >= 1)
        // Check that the X axis vanishing point was found. Must have a huge ratio between the x and the y from the center.
        let xAxisQualifying = vanishingPoints.filter() {
            let xDiff = abs($0.x - center.x)
            let yDiff = abs($0.y - center.y)
            let hasLargeRatio = $0.y - center.y == 0 || xDiff / yDiff > 300
            let hasDistantPoint = xDiff > 2000
            return hasLargeRatio && hasDistantPoint
        }
        XCTAssertTrue(xAxisQualifying.count >= 1)
        // Check that the Y axis vanishing point was found. Must have a huge ratio between the y and the x from the center.
        let yAxisQualifying = vanishingPoints.filter() {
            let xDiff = abs($0.x - center.x)
            let yDiff = abs($0.y - center.y)
            let hasLargeRatio = $0.x - center.x == 0 || yDiff / xDiff > 300
            let hasDistantPoint = yDiff > 2000
            return hasLargeRatio && hasDistantPoint
        }
        XCTAssertTrue(yAxisQualifying.count >= 1)
    }
}