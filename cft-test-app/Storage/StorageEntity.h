//
//  StorageEntity.h
//  cft-test-app
//
//  Created by Sergey Zubkov on 24.09.2018.
//  Copyright © 2018 Sergey Zubkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageEntity : NSObject
@property (nonatomic, strong) NSURL *original;
@property (nonatomic, strong) NSURL *thumbnail;
@end
