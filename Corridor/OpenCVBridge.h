//
//  OpenCVBridge.h
//  Corridor
//
//  Created by Greg Olmschenk on 2/23/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface OpenCVBridge : NSObject
+ (void) cannyWithImage:(UIImage*)image
                toEdges:(UIImage*)edges
         withThreshold1:(double)threshold1
         withThreshold2:(double)threshold2;
@end
 