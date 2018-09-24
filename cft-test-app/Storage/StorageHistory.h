//
//  Storage.h
//  ctf-test-app
//
//  Created by Sergey Zubkov on 23.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceEntity.h"
#import "StorageEntity.h"

@interface StorageHistory : NSObject
+ (StorageEntity*)saveImage:(UIImage*)image;
+ (UIImage*)loadImageWithURL:(NSURL*)url;
+ (void)removeFileWithURL:(NSURL*)url;

- (NSArray<DataSourceEntity*>*)loadHistory;
- (void)saveHistory:(NSArray<DataSourceEntity*>*)history;
@end
