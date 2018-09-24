//
//  RotateImageFilter.m
//  ctf-test-app
//
//  Created by Sergey Zubkov on 22.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import "RotateImageFilter.h"

@implementation RotateImageFilter

#pragma mark -
#pragma mark - ImageFilter

- (NSString*)filterName {
    return @"Rotate";
}

- (UIImage*)execute:(UIImage*)sourceImage {
    CGAffineTransform t = CGAffineTransformMakeRotation(M_PI_2);
    CGRect sizeRect = (CGRect) {.size = sourceImage.size};
    CGRect destRect = CGRectApplyAffineTransform(sizeRect, t);
    CGSize destinationSize = destRect.size;
    
    UIGraphicsBeginImageContext(destinationSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, destinationSize.width / 2.0f, destinationSize.height / 2.0f);
    CGContextRotateCTM(context, M_PI_2);
    [sourceImage drawInRect:CGRectMake(-sourceImage.size.width / 2.0f, -sourceImage.size.height / 2.0f, sourceImage.size.width, sourceImage.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
