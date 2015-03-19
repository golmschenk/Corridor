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
    
}