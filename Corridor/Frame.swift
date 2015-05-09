//
//  Frame.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/19/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import UIKit

class Frame {
    
    var image: UIImage! = nil
    var edgeImage: UIImage! = nil
    var twoDimensionalManhattanVanishingPointSet: TwoDimensionalManhattanVanishingPointSet!
    var contours = [[TwoDimensionalPoint]]()
    var lineSegments = [TwoDimensionalLineSegment]()
    var clusters = [Cluster]() // TODO - Just for debugging. Remove me.
    var vanishingPoints = [TwoDimensionalPoint]()
    
    init(image: UIImage) {
        self.image = image
    }
    
    func obtainCanny() {
        edgeImage = OpenCVBridge.canny(image)
    }
    
    func obtainContours() {
        let contour_ints = OpenCVBridge.findContours(edgeImage) as! [[[Int]]]
        // Convert the [[[Int]]] to [[TwoDimensionalPoint]].
        for contour in contour_ints {
            var points = [TwoDimensionalPoint]()
            for point_ints in contour {
                points.append(TwoDimensionalPoint(x: point_ints[0], y: point_ints[1]))
            }
            contours.append(points)
        }
    }
    
    func filterLineSegments(lineSegments: [TwoDimensionalLineSegment], byLength filterLength: Double) -> [TwoDimensionalLineSegment] {
        return lineSegments.filter() {$0.length >= filterLength}
    }
    
    func attainLineSegmentsFromContour(var contour: [TwoDimensionalPoint]) -> [TwoDimensionalLineSegment] {
        var lineSegments = [TwoDimensionalLineSegment]()
        // The potential line starts as just an individual point.
        var point = contour.removeLast()
        var potentialLineSegmentPointCloud = TwoDimensionalPointCloud(points: [point])
        while !contour.isEmpty {
            // Add the next point.
            point = contour.removeLast()
            potentialLineSegmentPointCloud.points.append(point)
            // If the point cloud is just a two points, we can immediately add the new point without checking.
            if potentialLineSegmentPointCloud.points.count == 2 {
                continue
            }
            // Calculate the standard deviation of the current line.
            let σ = potentialLineSegmentPointCloud.attainOrthogonalRegressionStandardDeviation()
            // Check if the standard deviation exceeds the limit.
            if σ > Constant.acceptableStandardDeviationOfLineSegment {
                // Remove the point.
                potentialLineSegmentPointCloud.points.removeLast()
                // Get the line segment for the point cloud.
                lineSegments.append(potentialLineSegmentPointCloud.attainLineSegment())
                // Create a new point cloud with the point that didn't fit.
                potentialLineSegmentPointCloud = TwoDimensionalPointCloud(points: [potentialLineSegmentPointCloud.points.last!, point])
                continue
            }
        }
        // ==Ending clean up.==
        // Get the line segment for the last point cloud.
        var potentialLineSegment = potentialLineSegmentPointCloud.attainLineSegment()
        // If there's at least one line segment in the list...
        if !lineSegments.isEmpty {
            // Check if the final line segment can extend the first one.
            if potentialLineSegment.canExtendLineSegment(lineSegments[0]) {
                lineSegments[0].mergeWithLineSegment(potentialLineSegment)
            } else {
                lineSegments.append(potentialLineSegment)
                // Check if the final point can extend the first line segment.
                if point.canExtendLineSegment(lineSegments[0]) {
                    // Merge the point into the line segment.
                    lineSegments[0].mergeInPoint(point)
                }
            }
        } else {
            lineSegments.append(potentialLineSegment)
        }
        return lineSegments
    }
    
    func obtainLineSegmentsFromContours(contours: [[TwoDimensionalPoint]], byLength length: Double = Constant.lineSegmentMinimumLength) {
        for contour in contours {
            var contourLineSegments = attainLineSegmentsFromContour(contour)
            contourLineSegments = filterLineSegments(contourLineSegments, byLength: length)
            lineSegments.extend(contourLineSegments)
        }
    }
    
    func obtainLineSegments() {
        obtainLineSegmentsFromContours(contours)
    }
    
    func generateVanishingPointModels(numberOfModels: Int = Constant.numberOfVanishingPointModels) -> [TwoDimensionalPoint] {
        var models = [TwoDimensionalPoint]()
        while models.count < numberOfModels {
            let lineSegment0 = lineSegments.randomItem()
            let lineSegment1 = lineSegments.randomItem()
            if lineSegment0 != lineSegment1 {
                if let vanishingPointModel = lineSegment0.findIntersectionWithLine(lineSegment1) {
                    models.append(vanishingPointModel)
                }
            }
        }
        return models
    }
    
    func attainInitialClusters() -> [Cluster] {
        let models = generateVanishingPointModels()
        var clusters = [Cluster]()
        for lineSegment in lineSegments {
            clusters.append(Cluster(lineSegments: [lineSegment], preferenceSet: map(models) { lineSegment.agreesWithVanishingPoint($0) }))
        }
        return clusters
    }
    
    func attainVanishingPoints() -> [TwoDimensionalPoint] {
        obtainCanny()
        obtainContours()
        obtainLineSegments()
        var clusters = attainInitialClusters()
        clusters = preformJLinkageMergingOnClusters(clusters)
        clusters = removeOutlierClusters(clusters)
        let vanishingPoints = attainVanishingPointsForClusters(clusters)
        self.clusters = clusters
        return vanishingPoints
    }
    
    func attainDebugAnnotatedImage(componentsToDraw: [String]) -> UIImage {
        if !contains(componentsToDraw, "do not process") {
            vanishingPoints = attainVanishingPoints()
        }
        
        UIGraphicsBeginImageContext(image.size)
        image.drawAtPoint(CGPoint(x: 0, y: 0))
        
        let context = UIGraphicsGetCurrentContext();
        
        // Contour drawing.
        if contains(componentsToDraw, "contours") {
            CGContextSetStrokeColorWithColor(context, UIColor.greenColor().CGColor)
            CGContextSetLineWidth(context, 4)
            for contour in contours {
                var pointIndex = 0
                while pointIndex < contour.count - 1 {
                    CGContextMoveToPoint(context, CGFloat(contour[pointIndex].x), CGFloat(contour[pointIndex].y))
                    CGContextAddLineToPoint(context, CGFloat(contour[pointIndex+1].x), CGFloat(contour[pointIndex+1].y))
                    CGContextStrokePath(context)
                    ++pointIndex
                }
                CGContextMoveToPoint(context, CGFloat(contour.last!.x), CGFloat(contour.last!.y))
                CGContextAddLineToPoint(context, CGFloat(contour.first!.x), CGFloat(contour.first!.y))
                CGContextStrokePath(context)
            }
        }
        
        // Line segment drawing.
        if contains(componentsToDraw, "line segments") {
            CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
            CGContextSetLineWidth(context, 4)
            for lineSegment in lineSegments {
                CGContextMoveToPoint(context, CGFloat(lineSegment.start.x), CGFloat(lineSegment.start.y));
                CGContextAddLineToPoint(context, CGFloat(lineSegment.end.x), CGFloat(lineSegment.end.y));
                CGContextStrokePath(context)
            }
        }
        
        // Cluster drawing.
        if contains(componentsToDraw, "clusters") {
            // Line segments of cluster.
            let context = UIGraphicsGetCurrentContext();
            var colorList = [UIColor.redColor().CGColor, UIColor.greenColor().CGColor, UIColor.blueColor().CGColor, UIColor.magentaColor().CGColor, UIColor.orangeColor().CGColor]
            for cluster in clusters {
                if colorList.count == 0 {
                    break
                }
                let color = colorList.removeAtIndex(0)
                CGContextSetStrokeColorWithColor(context, color)
                CGContextSetLineWidth(context, 4)
                for lineSegment in cluster.lineSegments {
                    CGContextMoveToPoint(context, CGFloat(lineSegment.start.x), CGFloat(lineSegment.start.y));
                    CGContextAddLineToPoint(context, CGFloat(lineSegment.end.x), CGFloat(lineSegment.end.y));
                    CGContextStrokePath(context)
                }
            }
            
            // Vanishing points of cluster.
            CGContextSetLineWidth(context, 7)
            colorList = [UIColor.redColor().CGColor, UIColor.greenColor().CGColor, UIColor.blueColor().CGColor, UIColor.magentaColor().CGColor, UIColor.orangeColor().CGColor]
            for vanishingPoint in vanishingPoints {
                if colorList.count == 0 {
                    break
                }
                let color = colorList.removeAtIndex(0)
                CGContextSetStrokeColorWithColor(context, color)
                let x = vanishingPoint.x
                let y = vanishingPoint.y
                let rect = CGRect(x: x-25, y: y-25, width: 50, height: 50)
                CGContextAddEllipseInRect(context, rect)
                CGContextStrokePath(context)
            }
        }
        
        let annotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return annotatedImage
    }
    
}
