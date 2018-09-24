//
//  FilterOperation.m
//  ctf-test-app
//
//  Created by Sergey Zubkov on 23.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import "FilterOperation.h"

@interface FilterOperation()
@property (strong) UIImage *sourceImage;
@property (strong) id<ImageFilter> filter;
@property (assign) NSInteger duration;
@end

@implementation FilterOperation

- (instancetype)initWithSourceImage:(UIImage*)sourceImage filter:(id<ImageFilter>)filter {
    if (self = [super init]) {
        self.sourceImage = sourceImage;
        self.filter = filter;
        self.duration = (5 + arc4random_uniform(5 - 5 + 1));
    }
    return self;
}

- (void)main {
    NSDate *startDate = [NSDate date];
    
    NSTimeInterval diffTime = [[NSDate date] timeIntervalSinceDate:startDate];
    while (diffTime < _duration) {
        CGFloat progress = MIN(1.0, diffTime / _duration);
        _progress = progress;
        
        if (_progressBlock) {
            _progressBlock(progress);
        }
        // test long job
        sleep(1);
        diffTime = [[NSDate date] timeIntervalSinceDate:startDate];
    }
    
    _progressBlock(1.0);
    _resultImage = [_filter execute:_sourceImage];
}

@end
