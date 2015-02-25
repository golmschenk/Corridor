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
    var contours: [[TwoDimensionalPoint]]!
    
    init(image: UIImage) {
        self.image = image
    }
    
    func obtainCanny() {
        edgeImage = OpenCVBridge.canny(image)
    }
    
    func obtainContours() {
        let contours_list = OpenCVBridge.findContours(edgeImage) as [[[Int]]]
    }
    
}
