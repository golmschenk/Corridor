//
//  OpenCVBridge.mm
//  Corridor
//
//  Created by Greg Olmschenk on 2/23/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//

#import "OpenCVBridge.h"
#import <opencv2/opencv.hpp>
#import <CoreGraphics/CoreGraphics.h>
#import "Corridor-Swift.h"


@implementation OpenCVBridge : NSObject

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

+ (UIImage*) canny:(UIImage*)image {
    cv::Mat imageMat, edgesMat;
    imageMat = [self cvMatFromUIImage:image];
    cv::Canny(imageMat, edgesMat, [ObjCConstant cannyLowThreshold], [ObjCConstant cannyLowThreshold]);
    UIImage* edges = [self UIImageFromCVMat:edgesMat];
    return edges;
}

+ (NSMutableArray*) TwoDimensionalPointNSArrayFromVector:(std::vector<std::vector<cv::Point2i>>)vector {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for(std::vector<std::vector<cv::Point2i>>::iterator it = vector.begin(); it != vector.end(); ++it) {
        NSMutableArray* array2 = [[NSMutableArray alloc] init];
        for(std::vector<cv::Point2i>::iterator it2 = it->begin(); it2 != it->end(); ++it2) {
            NSMutableArray* array3 = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:it2->x],
                                      [NSNumber numberWithInt:it2->y],
                                      nil];
            [array2 addObject:array3];
        }
        [array addObject:array2];
    }
    return array;
}

+ (NSArray*) findContours:(UIImage*)image {
    cv::Mat imageMat;
    imageMat = [self cvMatFromUIImage:image];
    std::vector<std::vector<cv::Point2i>> contoursVector;
    cv::findContours(imageMat, contoursVector, cv::RETR_LIST, cv::CHAIN_APPROX_SIMPLE);
    NSMutableArray* contours = [self TwoDimensionalPointNSArrayFromVector:contoursVector];
    return contours;
}

@end