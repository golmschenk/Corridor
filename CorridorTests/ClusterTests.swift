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
    
    func testJLinkageClusterMerging() {
        let preferenceSet0 = [true, true, true, false, false]
        let preferenceSet1 = [false, false, false, true, true]
        let preferenceSet2 = [false, true, true, true, false]
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 1, y: 1), end: TwoDimensionalPoint(x: 2, y: 2))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 2, y: 2), end: TwoDimensionalPoint(x: 3, y: 3))
        let lineSegment2 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 3, y: 3), end: TwoDimensionalPoint(x: 4, y: 4))
        let cluster0 = Cluster(lineSegments: [lineSegment0], preferenceSet: preferenceSet0)
        let cluster1 = Cluster(lineSegments: [lineSegment1], preferenceSet: preferenceSet1)
        let cluster2 = Cluster(lineSegments: [lineSegment2], preferenceSet: preferenceSet2)
        var clusters = [cluster0, cluster1, cluster2]
        
        clusters = preformJLinkageMergingOnClusters(clusters)
        
        XCTAssertEqual(clusters.count, 2)
        // These contains assume that newly added clusters are added to the end of the array. This may change depending on the merging process.
        XCTAssertTrue(contains(clusters[1].lineSegments, lineSegment0))
        XCTAssertTrue(contains(clusters[1].lineSegments, lineSegment2))
        XCTAssertTrue(contains(clusters[0].lineSegments, lineSegment1))
    }
    
    func testAverageVanishingPointFinding() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 5), end: TwoDimensionalPoint(x: 1, y: 5))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 7, y: 0), end: TwoDimensionalPoint(x: 7, y: 1))
        let lineSegment2 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 1, y: 1))
        let cluster = Cluster(lineSegments: [lineSegment0, lineSegment1, lineSegment2], preferenceSet: [])
        let expectedVanishingPoint = TwoDimensionalPoint(x: 6, y: 5)
        
        let vanishingPoint = cluster.vanishingPointFromAverage()
            
        XCTAssertEqual(vanishingPoint, expectedVanishingPoint)
    }
    
    func testVanishingPointsForAllClusters() {
        let lineSegment0 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 5), end: TwoDimensionalPoint(x: 1, y: 5))
        let lineSegment1 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 7, y: 0), end: TwoDimensionalPoint(x: 7, y: 1))
        let lineSegment2 = TwoDimensionalLineSegment(start: TwoDimensionalPoint(x: 0, y: 0), end: TwoDimensionalPoint(x: 1, y: 1))
        let cluster0 = Cluster(lineSegments: [lineSegment0, lineSegment2], preferenceSet: [])
        let cluster1 = Cluster(lineSegments: [lineSegment1, lineSegment2], preferenceSet: [])
        let clusters = [cluster0, cluster1]
        let expectedVanishingPoint0 = TwoDimensionalPoint(x: 5, y: 5)
        let expectedVanishingPoint1 = TwoDimensionalPoint(x: 7, y: 7)
        
        let vanishingPoints = attainVanishingPointsForClusters(clusters)
        
        XCTAssertTrue(contains(vanishingPoints, expectedVanishingPoint0))
        XCTAssertTrue(contains(vanishingPoints, expectedVanishingPoint1))
    }

}