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
    var edgeMap: [[Bool]]?
    
    init(image: UIImage) {
        self.image = image
    }
    
    func canny() {
        OpenCVBridge.cannyWithImage(image, toEdges: edgeImage, withThreshold1: 20, withThreshold2: 60)
    }
    
}
