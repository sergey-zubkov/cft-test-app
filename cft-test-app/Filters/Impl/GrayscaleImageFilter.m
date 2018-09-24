//
//  Grayscale.m
//  ctf-test-app
//
//  Created by Sergey Zubkov on 23.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import "GrayscaleImageFilter.h"

@implementation GrayscaleImageFilter

#pragma mark -
#pragma mark - ImageFilter

- (NSString*)filterName {
    return @"Grayscale";
}

- (UIImage*)execute:(UIImage*)sourceImage {
    CGRect sizeRect = (CGRect) {.size = sourceImage.size};
    CGRect destRect = sizeRect;
    CGSize destinationSize = destRect.size;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, destinationSize.width, destinationSize.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, destRect, [sourceImage CGImage]);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    return newImage;
}

@end
