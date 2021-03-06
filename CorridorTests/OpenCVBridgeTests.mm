//
//  OpenCVBridgeTests.m
//  Corridor
//
//  Created by Greg Olmschenk on 2/25/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <opencv2/opencv.hpp>
#import "OpenCVBridge.h"

@interface OpenCVBridge (Testing)

// Need the "private" methods being tested.
+ (NSMutableArray*) TwoDimensionalPointNSArrayFromVector:(std::vector<std::vector<cv::Point2i>>)vector;

@end

@interface OpenCVBridgeTests : XCTestCase
@end

@implementation OpenCVBridgeTests

- (void)testCanGetTwoDimensionalPointNSArrayFromVector
{
    std::vector<std::vector<cv::Point2i>> vector;
    std::vector<cv::Point2i> subvector1, subvector2;
    subvector1.push_back(cv::Point2i(1, 2));
    subvector1.push_back(cv::Point2i(3, 4));
    subvector2.push_back(cv::Point2i(5, 6));
    vector.push_back(subvector1);
    vector.push_back(subvector2);
    
    NSMutableArray* array = [OpenCVBridge TwoDimensionalPointNSArrayFromVector:vector];
    
    XCTAssertEqual([array count], 2);
    XCTAssertEqual([[array objectAtIndex:0] count], 2);
    XCTAssertEqual([[[[array objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] integerValue], 5);
}

@end
