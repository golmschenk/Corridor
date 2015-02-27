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
    
    func distanceFromPoint(point: TwoDimensionalPoint, toLine lineSegment: TwoDimensionalLineSegment) {
        let (x0, y0) = point.asTuple()
        let (x1, y1) = lineSegment.start.asTuple()
        let (x2, y2) = lineSegment.end.asTuple()
        //let distance = abs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1) / sqrt((y2-y1)^2 + (x2-x1)^2)
    }
    
    func doesPoint(point: TwoDimensionalPoint, extendLineSegment lineSegment: TwoDimensionalLineSegment) -> Bool {
        //TODO
        return true
    }
    
    func attainLineSegmentsFromContour(var contour: [TwoDimensionalPoint]) {
        var lineSegments = [TwoDimensionalLineSegment]()
        // The potential line starts as just an individual point.
        var point = contour.removeLast()
        var potentialLine = TwoDimensionalLineSegment(start: point, end: point)
        while !contour.isEmpty {
            point = contour.removeLast()
            // If the line is just a single point, we can immediately add the new point.
            if potentialLine.start == potentialLine.end {
                potentialLine.end = point
                continue
            }
            // Check if the new point is on or extends the line segment.
            if doesPoint(point, extendLineSegment: potentialLine) {
                //TODO
            }
        }
    }
    
}
