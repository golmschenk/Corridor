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
        var lastMergedPoint = point
        var potentialLineSegment = TwoDimensionalLineSegment(start: point, end: point)
        while !contour.isEmpty {
            point = contour.removeLast()
            // If the line is just a single point, we can immediately add the new point.
            if potentialLineSegment.start == potentialLineSegment.end {
                potentialLineSegment.end = point
                lastMergedPoint = point
                continue
            }
            // Check if the new point is on or extends the line segment.
            if point.canExtendLineSegment(potentialLineSegment) {
                // Merge the point into the line segment.
                potentialLineSegment.mergeInPoint(point)
                lastMergedPoint = point
                continue
            } else {
                lineSegments.append(potentialLineSegment)
                potentialLineSegment = TwoDimensionalLineSegment(start: lastMergedPoint, end: point)
                lastMergedPoint = point
                continue
            }
        }
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
    
    func attainAnnotatedImage() -> UIImage {
        vanishingPoints = attainVanishingPoints()
        
        UIGraphicsBeginImageContext(image.size)
        image.drawAtPoint(CGPoint(x: 0, y: 0))
        
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
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
