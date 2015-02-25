//
//  Constants.swift
//  Corridor
//
//  Created by Greg Olmschenk on 2/25/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

struct Constant {
    static let cannyLowThreshold = 20.0
    static let cannyHighThreshold = 60.0
}

@objc class ObjCConstant {
    class func cannyLowThreshold() -> Double { return Constant.cannyLowThreshold }
    class func cannyHighThreshold() -> Double { return Constant.cannyHighThreshold }
}