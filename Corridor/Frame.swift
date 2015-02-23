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
    let twoDimensionalManhattanVanishingPointSet: TwoDimensionalManhattanVanishingPointSet!
    var edgeMap: [[Bool]]?
    
    init(image: UIImage) {
        self.image = image
    }
    
}
