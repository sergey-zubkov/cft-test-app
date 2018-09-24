//
//  ImageEditorView.h
//  ctf-test-app
//
//  Created by Sergey Zubkov on 22.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFilter.h"

@class ImageEditorView;

@protocol ImageEditorViewDelegate<NSObject>
@optional
- (void)needSetImageEditor:(ImageEditorView*)imageEditor;
- (void)imageEditor:(ImageEditorView*)imageEditor pressedFilter:(id<ImageFilter>)filter;
@end

@interface ImageEditorView : UIView
@property (nonatomic, strong) NSArray<id<ImageFilter>> *filters;
@property (nonatomic, strong) UIImage *sourceImage;

@property (nonatomic, weak) id<ImageEditorViewDelegate> delegate;
@end
