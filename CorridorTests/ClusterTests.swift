//
//  ClusterTests.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/4/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import XCTest


class PreferenceSetTests: XCTestCase {
    
    func testUnion() {
        let preferenceSet0 = [true, true, false, false]
        let preferenceSet1 = [false, true, true, false]
        
        let preferenceSet2 = Cluster.preferenceSetUnion(preferenceSet0: preferenceSet0, preferenceSet1: preferenceSet1)
        
        XCTAssertEqual(preferenceSet2, [true, true, true, false])
    }
    
    func testIntersection() {
        let preferenceSet0 = [true, true, false, false]
        let preferenceSet1 = [false, true, true, false]
        
        let preferenceSet2 = Cluster.preferenceSetIntersection(preferenceSet0: preferenceSet0, preferenceSet1: preferenceSet1)
        
        XCTAssertEqual(preferenceSet2, [false, true, false, false])
    }
    
}