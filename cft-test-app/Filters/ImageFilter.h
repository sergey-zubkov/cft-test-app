//
//  ImageFilter.h
//  ctf-test-app
//
//  Created by Sergey Zubkov on 22.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageFilter<NSObject>
@required
@property (nonatomic, copy, readonly) NSString *filterName;
- (UIImage*)execute:(UIImage*)sourceImage;
@end
