//
//  LinearAlgebraTests.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/19/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import XCTest
import Darwin


class ColumnTests {
    func testColumnIndexing() {
        let column0 = Column([1, 2, 3, 4])
        let column1 = Column([5, 6])
        
        XCTAssertEqual(column0[1], 2)
        XCTAssertEqual(column1[1], 6)
    }
}

class MatrixTests: XCTestCase {
    
    func testMatrixIndexing() {
        let matrix = Matrix([[1, 2, 3],
                             [4, 5, 6],
                             [7, 8, 9]])
        
        XCTAssertEqual(matrix[2][1], 6)
        XCTAssertEqual(matrix[0][2], 7)
    }
    
    func testMatrixIndexingWithoutAutoTranspose() {
        let matrix = Matrix([[1, 2, 3],
                             [4, 5, 6],
                             [7, 8, 9]], autoTranspose: false)
        
        XCTAssertEqual(matrix[2][1], 8)
        XCTAssertEqual(matrix[0][2], 3)
    }
    
    func testMatrixTranspose() {
        let matrix0 = Matrix([[1, 2, 3],
                              [4, 5, 6]])
        
        let matrix1 = matrix0.transpose()
        
        XCTAssertEqual(matrix1[0][2], 3)
        XCTAssertEqual(matrix1[1][0], 4)
    }
    
    func testTransposeComputedProperty() {
        let matrix0 = Matrix([[1, 2, 3],
                              [4, 5, 6]])
        
        let matrix1 = matrix0.T
        
        XCTAssertEqual(matrix1[0][2], 3)
        XCTAssertEqual(matrix1[1][0], 4)
    }
    
    func testSize() {
        let matrix = Matrix([[1, 2, 3],
                             [4, 5, 6]])
        
        XCTAssertEqual(matrix.height, 2)
        XCTAssertEqual(matrix.width, 3)
    }
    
    func testDotProduct() {
        let matrix0 = Matrix([[1, 2, 3],
                              [4, 5, 6]])
        let matrix1 = Matrix([[ 7,  8],
                              [ 9, 10],
                              [11, 12]])
        
        let matrix2 = matrix0 • matrix1
        
        XCTAssertEqual(matrix2[1][0], 64)
        XCTAssertEqual(matrix2[1][1], 154)
    }
    
    func testCrossProduct() {
        let matrix0 = Matrix([[2, 3, 4]]).T
        let matrix1 = Matrix([[5, 6, 7]]).T
        
        let matrix2 = matrix0 × matrix1
        
        XCTAssertEqual(matrix2[0][0], -3)
        XCTAssertEqual(matrix2[1][0], 6)
    }
    
    func testTwoByTwoDeterminant() {
        let matrix = Matrix([[4, 6],
                             [3, 8]])
        
        let determinant = matrix.determinant()
        
        XCTAssertEqual(determinant, 14)
    }
    
    func testLargerDeterminant() {
        let matrix0 = Matrix([[6,  1, 1],
                             [4, -2, 5],
                             [2,  8, 7]])
        
        let matrix1 = Matrix([[3, 1, 1, 3],
                              [4, 5, 54, 6],
                              [6, 4, 7, 13],
                              [1, 6, 21, 71]])

        let determinant0 = matrix0.determinant()
        let determinant1 = matrix1.determinant()
        
        XCTAssertEqual(determinant0, -306)
        XCTAssertEqual(determinant1, -13516)
    }
    
    func testEquivalence() {
        let matrix0 = Matrix([[4, 6],
                              [3, 8]])
        let matrix1 = Matrix([[4, 6],
                              [3, 8]])
        let matrix2 = Matrix([[4, 6],
                              [3, 8],
                              [3, 8]])
        let matrix3 = Matrix([[4, 7],
                              [3, 8]])
        
        XCTAssertTrue(matrix0 == matrix1)
        XCTAssertTrue(matrix0 != matrix2)
        XCTAssertTrue(matrix0 != matrix3)
    }
    
    func testScalarMultiplication() {
        let matrix0 = Matrix([[4, 6],
                              [3, 8]])
        let matrix1 = Matrix([[8, 12],
                              [6, 16]])
        
        let matrix2 = 2 * matrix0
        
        XCTAssertEqual(matrix2, matrix1)
    }
    
    func testTwoByTwoInverse() {
        let matrix0 = Matrix([[4, 6],
                              [3, 8]])
        
        let determinant = matrix0.determinant()
        
        XCTAssertEqual(determinant, 14)
    }
    
    func testFourByFourInverse() {
        let matrix0 = Matrix([[ 3,  5, 7, -7],
                              [27, -7, 2,  1],
                              [ 6,  4, 7,  2],
                              [17,  1, 1,  1]])
        let column0 = [7.0/1486.0, 8.0/2229.0, -31.0/2229.0, 85.0/1486.0]
        let column1 = [13.0/1486.0, -167.0/1486.0, -3.0/1486.0, 132.0/743.0]
        let column2 = [17.0/743.0, 145.0/2229.0, 274.0/2229.0, -112.0/743.0]
        let column3 = [-83.0/743.0, -61.0/4458.0, 515.0/4458.0, 1.0/1486.0]
        let matrix1Expected = Matrix([column0, column1, column2, column3])
        
        let matrix1 = matrix0.inverse()
        
        XCTAssertTrue(matrix1 ≈≈ matrix1Expected)
    }
    
    func testAddColumn() {
        let matrix = Matrix([[1, 2],
                             [4, 5],
                             [7, 8]])
        let column = Column([3, 6, 9])
        let expectedMatrix = Matrix([[1, 2, 3],
                                     [4, 5, 6],
                                     [7, 8, 9]])
        
        matrix.addColumn(column)
        
        XCTAssertEqual(matrix, expectedMatrix)
    }
    
    func testRemoveColumn() {
        let expectedMatrix = Matrix([[1, 2],
            [4, 5],
            [7, 8]])
        let matrix = Matrix([[1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]])
        
        matrix.removeColumn(2)
        
        XCTAssertEqual(matrix, expectedMatrix)
    }
    
    func testAddRow() {
        let matrix = Matrix([[1, 2, 3],
                             [4, 5, 6]])
        let row : [Double] = [7, 8, 9]
        let expectedMatrix = Matrix([[1, 2, 3],
                                     [4, 5, 6],
                                     [7, 8, 9]])
        
        matrix.addRow(row)
        
        XCTAssertEqual(matrix, expectedMatrix)
    }
    
    func testRemoveRow() {
        let expectedMatrix = Matrix([[1, 2, 3],
                                     [4, 5, 6]])
        let matrix = Matrix([[1, 2, 3],
                             [4, 5, 6],
                             [7, 8, 9]])
        
        matrix.removeRow(2)
        
        XCTAssertEqual(matrix, expectedMatrix)
    }
    
    func testInverseIsReverseTransformation() {
        var point0 = Matrix([[-2], [0], [3]])
        point0.addRow([1])
        var point1 = Matrix([[2], [0], [2]])
        point1.addRow([1])
        var transformation = Matrix([[ cos(π/2), 0, sin(π/2), -1],
                                     [        0, 1,        0, 0],
                                     [-sin(π/2), 0, cos(π/2), 0]])
        transformation.addRow([0, 0, 0, 1])
        
        var point1expected = transformation • point0
        point1expected.removeRow(3)
        var point0expected = transformation.inverse() • point1
        point0expected.removeRow(3)
        point0.removeRow(3)
        point1.removeRow(3)
        
        XCTAssertTrue(point0 ≈≈ point0expected)
        XCTAssertTrue(point1 ≈≈ point1expected)
    }
    
    func testTransformPoint() {
        var point0 = Matrix([[-2], [0], [3]])
        var transformation = Matrix([[ cos(π/2), 0, sin(π/2), -1],
                                     [        0, 1,        0, 0],
                                     [-sin(π/2), 0, cos(π/2), 0]])
        var expected1Point = Matrix([[2], [0], [2]])
        
        let point1 = point0.transform(transformation)
        
        XCTAssertEqual(point1, expected1Point)
    }
    
    func testApplyCameraMatrix() {
        // Intrinsic camera matrix for F=35mm
        let K = Matrix([[35,  0, 0],
                        [ 0, 35, 0],
                        [ 0,  0, 1]])
        // Rotation matrix of 10 degrees on y
        var R = Matrix([[ cos(radiansFromDegrees(10)), 0, sin(radiansFromDegrees(10))],
                        [                           0, 1,                           0],
                        [-sin(radiansFromDegrees(10)), 0, cos(radiansFromDegrees(10))]])
        // Camera offset by -0.5m in the x direction
        let T = Matrix([[-500],
                        [   0],
                        [   0]])
        // Geting P for this camera.
        var RT = R
        RT.addColumn(T.columns[0])
        RT.addRow([0, 0, 0, 1])
        var PwoK = RT.inverse()
        PwoK.removeRow(3)
        let P = K • PwoK
        
        let point0 = Matrix([[0], [0], [2835.64090981]])
        let expectedTransformedPoint0 = Matrix([[0], [0], [1]])
        let point1 = Matrix([[0], [0], [Double(FLT_MAX)]])
        let expectedTransformedPoint1 = Matrix([[-6.1714443248], [0], [1]])
        
        let transformedPoint0 = point0.applyCameraMatrix(P)
        let transformedPoint1 = point1.applyCameraMatrix(P)
        
        XCTAssertTrue(transformedPoint0 ≈≈ expectedTransformedPoint0)
        XCTAssertTrue(transformedPoint1 ≈≈ expectedTransformedPoint1)
    }
    
    func testWritingToSpecificCellWithDoubleSubscript() {
        let matrix = Matrix([[1, 2, 3],
                             [4, 5, 6],
                             [7, 8, 9]])
        let expectedMatrix = Matrix([[1, 2, 3],
                                     [4, 5, 0],
                                     [7, 8, 9]])
        
        matrix[2][1] = 0
        
        XCTAssertEqual(matrix, expectedMatrix)
    }
    
    func testSwapRows() {
        let matrix = Matrix([[1, 2, 3],
                             [4, 5, 6],
                             [7, 8, 9]])
        let expectedMatrix = Matrix([[1, 2, 3],
                                     [7, 8, 9],
                                     [4, 5, 6]])
        
        matrix.swapRows(1, 2)
        
        XCTAssertEqual(matrix, expectedMatrix)
    }
    
    func testAttainReducedRowEchelonForm() {
        let matrix = Matrix([[1, 2, -1, -4],
                             [2, 3, -1, -11],
                             [-2, 0, -3, 22]])
        let expectedMatrix = Matrix([[1, 0, 0, -8],
                                     [0, 1, 0, 1],
                                     [0, 0, 1, -2]])
        
        matrix.convertToReducedRowEchelonForm()
        
        XCTAssertEqual(matrix, expectedMatrix)
    }
    
    func testSolveApproximateLinearEquation() {
        let A = Matrix([[2, -1],
                        [1, 2],
                        [1, 1]])
        let b = Matrix([[2],
                        [1],
                        [4]])
        let expectedSolution = Matrix([[10.0/7.0],
                                       [3.0/7.0]])
        
        let solution = Matrix.generateSolutionForApproximateLinearEquation(A: A, b: b)
        
        XCTAssertTrue(solution ≈≈ expectedSolution)
    }
}
