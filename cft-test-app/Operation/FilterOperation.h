//
//  FilterOperation.h
//  ctf-test-app
//
//  Created by Sergey Zubkov on 23.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFilter.h"

@interface FilterOperation : NSOperation
NS_ASSUME_NONNULL_BEGIN
- (instancetype)initWithSourceImage:(UIImage*)sourceImage filter:(id<ImageFilter>)filter;

@property (nullable, copy) void (^progressBlock)(CGFloat progress);
@property (assign) CGFloat progress;
@property (strong) UIImage *resultImage;
NS_ASSUME_NONNULL_END
@end
