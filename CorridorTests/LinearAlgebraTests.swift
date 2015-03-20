//
//  LinearAlgebraTests.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/19/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import XCTest


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
    
    /*func testTwoByTwoInverse() {
        let matrix0 = Matrix([[4, 6],
                              [3, 8]])
        
        let determinant = matrix0.determinant()
        
        XCTAssertEqual(determinant, 14)
    }*/
    
}
