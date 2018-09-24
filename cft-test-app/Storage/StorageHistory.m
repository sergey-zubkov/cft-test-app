//
//  Storage.m
//  ctf-test-app
//
//  Created by Sergey Zubkov on 23.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import "StorageHistory.h"

@implementation StorageHistory

+ (StorageEntity*)saveImage:(UIImage*)image {
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"HH.mm.ss.SSS.dd.yyyy";
    
    NSString *fileNameOriginal = [[dateFormater stringFromDate:[NSDate new]] stringByAppendingString:@".png"];
    NSString *fileNameThumbnail = [[dateFormater stringFromDate:[NSDate new]] stringByAppendingString:@".thumbnail.png"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (paths.count < 1) {
        return nil;
    }
    
    NSString *imageFilePathOriginal = [paths[0] stringByAppendingPathComponent:fileNameOriginal];
    NSString *imageFilePathThumbnail = [paths[0] stringByAppendingPathComponent:fileNameThumbnail];

    NSData *imageDataOriginal = UIImagePNGRepresentation(image);
    NSData *imageDataThumbnail = UIImagePNGRepresentation([StorageHistory thumbnail:image]);
    
    NSURL *urlToFileOriginal = [NSURL fileURLWithPath:imageFilePathOriginal];
    NSURL *urlToFileThumbnail = [NSURL fileURLWithPath:imageFilePathThumbnail];
    
    NSError *error = nil;
    [imageDataOriginal writeToURL:urlToFileOriginal options:NSDataWritingAtomic error:&error];
    if (error != nil ) {
        NSLog(@"%@", [error localizedDescription]);
    }

    [imageDataThumbnail writeToURL:urlToFileThumbnail options:NSDataWritingAtomic error:&error];
    if (error != nil ) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    StorageEntity *storageEntity = [StorageEntity new];
    storageEntity.original = urlToFileOriginal;
    storageEntity.thumbnail = urlToFileThumbnail;
    
    return storageEntity;
}

+ (UIImage*)loadImageWithURL:(NSURL*)url {
    NSError *error = nil;
    NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedAlways error:&error];
    if (error != nil ) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    return [UIImage imageWithData:imageData];
}

+ (void)removeFileWithURL:(NSURL*)url {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    [fileManager removeItemAtURL:url error:&error];
    if (error != nil ) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

+ (UIImage*)thumbnail:(UIImage*)originalImage {
    CGFloat maxEdge = MAX(originalImage.size.width, originalImage.size.height);
    if (maxEdge == 0) {
        return originalImage;
    }
    CGFloat coeff = 100 / maxEdge * [UIScreen mainScreen].scale;
    CGSize thumbnailSize = CGSizeMake(originalImage.size.width * coeff, originalImage.size.height * coeff);
    
    UIGraphicsBeginImageContext(thumbnailSize);
    [originalImage drawInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnail;
}

- (NSArray<DataSourceEntity*>*)loadHistory {
    NSData *historyData = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
    NSArray<DataSourceEntity*> *notes = [NSKeyedUnarchiver unarchiveObjectWithData:historyData];
    
    return notes;
}

- (void)saveHistory:(NSArray<DataSourceEntity*>*)history {
    __block NSMutableArray<DataSourceEntity*> *filteredHistory = [NSMutableArray new];
    [history enumerateObjectsUsingBlock:^(DataSourceEntity *object, NSUInteger index, BOOL *stop) {
        if (object.imageURLOriginal != nil && object.imageURLThumbnail != nil) {
            [filteredHistory addObject:object];
        }
    }];
    
    NSData *historyData = [NSKeyedArchiver archivedDataWithRootObject:filteredHistory];
    [[NSUserDefaults standardUserDefaults] setObject:historyData forKey:@"history"];
}

@end
