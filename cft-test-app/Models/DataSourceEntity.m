//
//  DataSourceEntity.m
//  ctf-test-app
//
//  Created by Sergey Zubkov on 23.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import "DataSourceEntity.h"

@implementation DataSourceEntity

#pragma mark -
#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.imageURLOriginal  = [aDecoder decodeObjectForKey:@"image-original-url"];
        self.imageURLThumbnail = [aDecoder decodeObjectForKey:@"image-thumbnail-url"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_imageURLOriginal forKey:@"image-original-url"];
    [aCoder encodeObject:_imageURLThumbnail forKey:@"image-thumbnail-url"];
}

@end
