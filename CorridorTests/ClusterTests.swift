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
    
    func testSum() {
        let preferenceSet = [true, true, false, true]
        
        let sum = Cluster.preferenceSetSum(preferenceSet)
        
        XCTAssertEqual(sum, 3)
    }
    
}

class ClusterTests: XCTestCase {

    func testClusterMerging() {
        let preferenceSet0 = [true, true, false, false]
        let preferenceSet1 = [false, true, true, false]
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 1, y: 1), end: TwoDimensionalPoint(x: 2, y: 2))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: -1, y: 1), end: TwoDimensionalPoint(x: -2, y: 2))
        let cluster0 = Cluster(lineSegments: [lineSegment0], preferenceSet: preferenceSet0)
        let cluster1 = Cluster(lineSegments: [lineSegment1], preferenceSet: preferenceSet1)
        let cluster2Expected1 = Cluster(lineSegments: [lineSegment1, lineSegment0], preferenceSet: [false, true, false, false])
        let cluster2Expected2 = Cluster(lineSegments: [lineSegment0, lineSegment1], preferenceSet: [false, true, false, false])
        
        let cluster2 = cluster0.mergeWithCluster(cluster1)
        
        // Need to check both directions as the order of the line segment list matters.
        XCTAssertTrue(cluster2 == cluster2Expected1 || cluster2 == cluster2Expected2)
    }
    
    func testEquivalence() {
        let preferenceSet0 = [true, true, false, false]
        let preferenceSet1 = [false, true, false, false]
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 1, y: 1), end: TwoDimensionalPoint(x: 2, y: 2))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: -1, y: 1), end: TwoDimensionalPoint(x: -2, y: 2))
        let cluster0 = Cluster(lineSegments: [lineSegment0, lineSegment1], preferenceSet: preferenceSet0)
        let cluster1 = Cluster(lineSegments: [lineSegment1], preferenceSet: preferenceSet0)
        let cluster2 = Cluster(lineSegments: [lineSegment1], preferenceSet: preferenceSet1)
        
        XCTAssertFalse(cluster0 == cluster1)
        XCTAssertFalse(cluster1 == cluster2)
    }
    
    func testJaccardDistanceBetweenClusters() {
        let preferenceSet0 = [true, true, false, false]
        let preferenceSet1 = [false, true, true, false]
        let preferenceSet2 = [false, false, true, true]
        let cluster0 = Cluster(lineSegments: [], preferenceSet: preferenceSet0)
        let cluster1 = Cluster(lineSegments: [], preferenceSet: preferenceSet1)
        let cluster2 = Cluster(lineSegments: [], preferenceSet: preferenceSet2)
        
        XCTAssertEqual(cluster0.jaccardDistanceToCluster(cluster0), 0.0)
        XCTAssertEqual(cluster0.jaccardDistanceToCluster(cluster1), 2.0/3.0)
        XCTAssertEqual(cluster0.jaccardDistanceToCluster(cluster2), 1.0)
        XCTAssertEqual(cluster1.jaccardDistanceToCluster(cluster2), 2.0/3.0)
    }

}