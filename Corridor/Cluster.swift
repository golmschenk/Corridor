//
//  Cluster.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/4/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

struct Cluster {
    var lineSegments: [TwoDimensionalLineSegment]
    var preferenceSet: [Bool]
    
    static func preferenceSetUnion(#preferenceSet0: [Bool], preferenceSet1: [Bool]) -> [Bool] {
        return map(0..<preferenceSet0.count) { preferenceSet0[$0] || preferenceSet1[$0] }
    }
    
    /*func mergeWithCluster(cluster: Cluster) -> Cluster {
        
    }*/
}
