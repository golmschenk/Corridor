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
    
    func jaccardDistanceToCluster(cluster: Cluster) -> Double {
        let union = Cluster.preferenceSetUnion(preferenceSet0: self.preferenceSet, preferenceSet1: cluster.preferenceSet)
        let intersection = Cluster.preferenceSetIntersection(preferenceSet0: self.preferenceSet, preferenceSet1: cluster.preferenceSet)
        let unionSum = Double(Cluster.preferenceSetSum(union))
        let intersectionSum = Double(Cluster.preferenceSetSum(intersection))
        return (unionSum - intersectionSum) / unionSum
    }
    
    /*func vanishingPointFromAverage() -> TwoDimensionalPoint {
        var vanishingPointSum = [TwoDimensionalPoint]()
        for index0 in 0..<self.lineSegments.count {
            for index1 in index0+1..<self.lineSegments.count {
                
            }
        }
    }*/
    
}

func == (cluster0: Cluster, cluster1: Cluster) -> Bool {
    return cluster0.lineSegments == cluster1.lineSegments && cluster0.preferenceSet == cluster1.preferenceSet
}

func preformJLinkageMergingOnClusters(var clusters: [Cluster]) -> [Cluster] {
    var minimumDistance = 0.0
    var mergeIndex0: Int?
    var mergeIndex1: Int?
    while minimumDistance < 1.0 {
        if mergeIndex0 != nil && mergeIndex1 != nil {
            let newCluster = clusters[mergeIndex0!].mergeWithCluster(clusters[mergeIndex1!])
            clusters.removeAtIndex(max(mergeIndex0!, mergeIndex1!))
            clusters.removeAtIndex(min(mergeIndex0!, mergeIndex1!))
            clusters.append(newCluster)
        }
        minimumDistance = 1.0
        outerFor : for (index0, cluster0) in enumerate(clusters) {
            for (index1, cluster1) in enumerate(clusters) {
                if index0 != index1 {
                    let distance = cluster0.jaccardDistanceToCluster(cluster1)
                    if distance < minimumDistance {
                        minimumDistance = distance
                        mergeIndex0 = index0
                        mergeIndex1 = index1
                        if minimumDistance == 0.0 {
                            break outerFor
                        }
                    }
                }
            }
        }
    }
    return clusters
}