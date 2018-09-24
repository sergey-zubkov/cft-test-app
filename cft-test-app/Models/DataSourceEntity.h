//
//  DataSourceEntity.h
//  ctf-test-app
//
//  Created by Sergey Zubkov on 23.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterOperation.h"

@interface DataSourceEntity : NSObject<NSCoding>
@property (nonatomic, strong) FilterOperation *operation;
@property (nonatomic, strong) NSURL *imageURLOriginal;
@property (nonatomic, strong) NSURL *imageURLThumbnail;
@end
