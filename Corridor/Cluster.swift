//
//  Cluster.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/4/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

struct Cluster : Equatable {
    var lineSegments: [TwoDimensionalLineSegment]
    var preferenceSet: [Bool]
    
    static func preferenceSetUnion(#preferenceSet0: [Bool], preferenceSet1: [Bool]) -> [Bool] {
        return map(0..<preferenceSet0.count) { preferenceSet0[$0] || preferenceSet1[$0] }
    }
    
    static func preferenceSetIntersection(#preferenceSet0: [Bool], preferenceSet1: [Bool]) -> [Bool] {
        return map(0..<preferenceSet0.count) { preferenceSet0[$0] && preferenceSet1[$0] }
    }
    
    static func preferenceSetSum(preferenceSet: [Bool]) -> Int {
        return reduce(preferenceSet, 0) { $0 + ($1 ? 1 : 0) }
    }
    
    func mergeWithCluster(cluster: Cluster) -> Cluster {
        return Cluster(lineSegments: self.lineSegments + cluster.lineSegments, preferenceSet: Cluster.preferenceSetIntersection(preferenceSet0: self.preferenceSet, preferenceSet1: cluster.preferenceSet))
    }
    
    /*func jaccardDistanceToCluster(cluster: Cluster) -> Double {
        
    }*/
    
}

func == (cluster0: Cluster, cluster1: Cluster) -> Bool {
    return cluster0.lineSegments == cluster1.lineSegments && cluster0.preferenceSet == cluster1.preferenceSet
}

/*func preformJLinkageMergingOnClusters(var clusters: [Cluster]) -> [Cluster] {
    // TODO
    return clusters
}*/