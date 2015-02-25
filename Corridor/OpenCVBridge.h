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
+ (UIImage*) canny:(UIImage*)image;
+ (NSArray*) findContours:(UIImage*)image;
@end
 