//
//  Cluster.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/4/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

class Cluster : Equatable {
    var lineSegments = [TwoDimensionalLineSegment]()
    var preferenceSet = [Bool]()
    var jaccardDistances = [Double?]()
    
    init(lineSegments: [TwoDimensionalLineSegment], preferenceSet: [Bool]) {
        self.lineSegments = lineSegments
        self.preferenceSet = preferenceSet
    }
    
    class func preferenceSetUnion(#preferenceSet0: [Bool], preferenceSet1: [Bool]) -> [Bool] {
        return map(0..<preferenceSet0.count) { preferenceSet0[$0] || preferenceSet1[$0] }
    }
    
    class func preferenceSetIntersection(#preferenceSet0: [Bool], preferenceSet1: [Bool]) -> [Bool] {
        return map(0..<preferenceSet0.count) { preferenceSet0[$0] && preferenceSet1[$0] }
    }
    
    class func preferenceSetSum(preferenceSet: [Bool]) -> Int {
        return reduce(preferenceSet, 0) { $0 + ($1 ? 1 : 0) }
    }
    
    func mergeWithCluster(cluster: Cluster) -> Cluster {
        return Cluster(lineSegments: lineSegments + cluster.lineSegments, preferenceSet: Cluster.preferenceSetIntersection(preferenceSet0: self.preferenceSet, preferenceSet1: cluster.preferenceSet))
    }
    
    func jaccardDistanceToCluster(cluster: Cluster) -> Double {
        let union = Cluster.preferenceSetUnion(preferenceSet0: self.preferenceSet, preferenceSet1: cluster.preferenceSet)
        let intersection = Cluster.preferenceSetIntersection(preferenceSet0: self.preferenceSet, preferenceSet1: cluster.preferenceSet)
        let unionSum = Double(Cluster.preferenceSetSum(union))
        let intersectionSum = Double(Cluster.preferenceSetSum(intersection))
        return (unionSum - intersectionSum) / unionSum
    }
    
    func vanishingPointFromAverage() -> TwoDimensionalPoint {
        var vanishingPointSum = TwoDimensionalPoint(x: 0, y: 0)
        for index0 in 0..<self.lineSegments.count {
            for index1 in index0+1..<self.lineSegments.count {
                if let vanishingPoint = self.lineSegments[index0].findIntersectionWithLine(self.lineSegments[index1]) {
                    vanishingPointSum = vanishingPointSum + vanishingPoint
                }
            }
        }
        return vanishingPointSum / choose2(from: self.lineSegments.count)
    }
}

func == (cluster0: Cluster, cluster1: Cluster) -> Bool {
    return cluster0.lineSegments == cluster1.lineSegments && cluster0.preferenceSet == cluster1.preferenceSet
}

func attainMinimumJaccardDistanceTuple(jaccardDistances: [Double?]) -> (Int?, Double?) {
    let startTuple : (Int?, Double?) = (nil, 1)
    return reduce(enumerate(jaccardDistances), startTuple) { (($1.1 ?? 1) < $0.1!) ? ($1.0, $1.1) : ($0.0, $0.1) } //TODO - Recalculating the minimum every round is unnecessary. Since only two (or three) clusters change on every merge, we just need to have a sorted list and add them to the list.
}

func attainMinimumJaccardDistanceTupleFromTupleList(tupleList: [(Int?, Double?)]) -> (Int?, Int?, Double?) {
    let startTuple : (Int?, Int?, Double?) = (nil, nil, 1)
    return reduce(enumerate(tupleList), startTuple) { (($1.1.1 ?? 1) < $0.2!) ? ($1.0, $1.1.0, $1.1.1) : ($0.0, $0.1, $0.2) } //TODO - Maybe on this recalculating the minimum every round is unnecessary. Since only two (or three) clusters change on every merge, we might just be able to have a giant sorted list.
    //TODO - This function is near incomprehendable.
}

func preformJLinkageMergingOnClusters(var clusters: [Cluster]) -> [Cluster] {
    // Calculate the distance between all pairs.
    for (index, cluster0) in enumerate(clusters) {
        cluster0.jaccardDistances.append(nil) // Don't consider distance to self.
        for cluster1 in clusters[index+1..<clusters.count] {
            // Set the distance in both clusters.
            let distance = cluster0.jaccardDistanceToCluster(cluster1)
            cluster0.jaccardDistances.append(distance)
            cluster1.jaccardDistances.append(distance)
        }
    }
    while true {
        // Find the closest pairs.
        let minTupleList = map(clusters) { attainMinimumJaccardDistanceTuple($0.jaccardDistances) }
        let minTuple = attainMinimumJaccardDistanceTupleFromTupleList(minTupleList)
        if minTuple.0 == nil {
            break
        }
        // Merge the closest pairs.
        let small = min(minTuple.0!, minTuple.1!)
        let large = max(minTuple.0!, minTuple.1!)
        let newCluster = clusters[small].mergeWithCluster(clusters[large])
        // Remove the old clusters.
        clusters.removeAtIndex(large)
        clusters.removeAtIndex(small)
        for cluster in clusters {
            cluster.jaccardDistances.removeAtIndex(large)
            cluster.jaccardDistances.removeAtIndex(small)
        }
        // Calculate the new cluster against all the old.
        for cluster in clusters {
            // Set the distance in both clusters.
            let distance = newCluster.jaccardDistanceToCluster(cluster)
            newCluster.jaccardDistances.append(distance)
            cluster.jaccardDistances.append(distance)
        }
        newCluster.jaccardDistances.append(nil) // Don't consider distance to self.
        clusters.append(newCluster)
    }
    return clusters
}

func attainVanishingPointsForClusters(clusters: [Cluster]) -> [TwoDimensionalPoint]{
    return map(clusters) { $0.vanishingPointFromAverage() }
}

func removeOutlierClusters(clusters: [Cluster]) -> [Cluster] {
    return filter(clusters) { $0.lineSegments.count > 2 }
}