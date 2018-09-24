//
//  FilterResultCell.m
//  ctf-test-app
//
//  Created by Sergey Zubkov on 23.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import "FilterResultCell.h"
#import "StorageHistory.h"

@interface FilterResultCell()
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIImageView *imageResultView;
@end

@implementation FilterResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setEntity:(DataSourceEntity *)entity {
    _entity = entity;
    
    if (entity.imageURLThumbnail != nil) {
        _imageResultView.hidden = NO;
        _progress.hidden = YES;
        
        NSURL *imageURL = [entity.imageURLThumbnail copy];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            UIImage *image = [StorageHistory loadImageWithURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if ([imageURL isEqual:_entity.imageURLThumbnail]) {
                    _imageResultView.image = image;
                }
            });
        });
        
    } else {
        _imageResultView.hidden = YES;
        _progress.hidden = NO;
        _progress.progress = entity.operation.progress;
    }
}

@end
