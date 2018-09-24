//
//  MirrorImageFilter.m
//  ctf-test-app
//
//  Created by Sergey Zubkov on 23.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import "MirrorImageFilter.h"

@implementation MirrorImageFilter

#pragma mark -
#pragma mark - ImageFilter

- (NSString*)filterName {
    return @"Mirror";
}

- (UIImage*)execute:(UIImage*)sourceImage {
    CGRect sizeRect = (CGRect) {.size = sourceImage.size};
    CGRect destRect = sizeRect;
    CGSize destinationSize = destRect.size;
    
    UIGraphicsBeginImageContext(destinationSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, destinationSize.width / 2.0f, destinationSize.height / 2.0f);
    CGContextConcatCTM(context, CGAffineTransformMakeScale(-1.0, 1.0));
    
    [sourceImage drawInRect:CGRectMake(-sourceImage.size.width / 2.0f, -sourceImage.size.height / 2.0f, sourceImage.size.width, sourceImage.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
