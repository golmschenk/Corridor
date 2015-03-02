//
//  Frame.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/19/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

import UIKit

class Frame {
    
    let image: UIImage! = nil
    var edgeImage: UIImage! = nil
    let twoDimensionalManhattanVanishingPointSet: TwoDimensionalManhattanVanishingPointSet!
    var contours = [[TwoDimensionalPoint]]()
    
    init(image: UIImage) {
        self.image = image
    }
    
    func obtainCanny() {
        edgeImage = OpenCVBridge.canny(image)
    }
    
    func obtainContours() {
        let contour_ints = OpenCVBridge.findContours(edgeImage) as [[[Int]]]
        // Convert the [[[Int]]] to [[TwoDimensionalPoint]].
        for contour in contour_ints {
            var points = [TwoDimensionalPoint]()
            for point_ints in contour {
                points.append(TwoDimensionalPoint(x: point_ints[0], y: point_ints[1]))
            }
            contours.append(points)
        }
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
    
}
