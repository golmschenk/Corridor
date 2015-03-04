//
//  Utility.swift
//  Corridor
//
//  Created by Greg Olmschenk on 3/4/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

extension Array {
    func randomItem() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}