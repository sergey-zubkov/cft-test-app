//
//  ImageEditorView.m
//  ctf-test-app
//
//  Created by Sergey Zubkov on 22.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import "ImageEditorView.h"

@interface ImageEditorView()
@property (nonatomic, strong) UIImageView *sourceImageView;
@property (nonatomic, strong) NSMutableArray<UIButton*> *filterButtons;
@end

@implementation ImageEditorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializer];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    self.backgroundColor = [UIColor greenColor];
    
    self.sourceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.sourceImageView.backgroundColor = [UIColor blueColor];
    [self addSubview:_sourceImageView];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sourceImagePressed:)];
    self.sourceImageView.userInteractionEnabled = YES;
    [self.sourceImageView addGestureRecognizer:recognizer];
}

- (void)layoutSubviews {
    CGFloat edgeSourceImage = MIN(self.frame.size.height, self.frame.size.width / 2);
    self.sourceImageView.frame = CGRectMake(0, 0, edgeSourceImage, edgeSourceImage);
    
    CGRect buttonsRect = CGRectMake(_sourceImageView.frame.origin.x + _sourceImageView.frame.size.width + 8, 0, self.frame.size.width - (_sourceImageView.frame.origin.x + _sourceImageView.frame.size.width + 8), 0);
    for (UIButton *button in _filterButtons) {
        button.frame = CGRectMake(buttonsRect.origin.x, buttonsRect.origin.y, buttonsRect.size.width, 30);
        buttonsRect.origin.y += (30 + 8);
    }
}

- (void)setFilters:(NSArray<id<ImageFilter>> *)filters {
    _filters = filters;
    
    for (UIButton *button in _filterButtons) {
        [button removeFromSuperview];
    }
    
    self.filterButtons = [NSMutableArray new];
    
    NSInteger tag = 0;
    for (id<ImageFilter> filter in filters) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:filter.filterName forState:UIControlStateNormal];
        [button setTag:tag++];
        [button setBackgroundColor:[UIColor yellowColor]];
        [button addTarget:self action:@selector(filterPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.filterButtons addObject:button];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSourceImage:(UIImage *)sourceImage {
    _sourceImage = sourceImage;
    _sourceImageView.image = sourceImage;
}

- (void)filterPressed:(UIButton*)button {
    if (self.sourceImage == nil) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(imageEditor:pressedFilter:)]) {
        [_delegate imageEditor:self pressedFilter:_filters[button.tag]];
    }
}

- (void)sourceImagePressed:(UIGestureRecognizer*)recognizer {
    if ([_delegate respondsToSelector:@selector(needSetImageEditor:)]) {
        [_delegate needSetImageEditor:self];
    }
}

#pragma mark -
#pragma mark - UIConstraintBasedLayoutLayering

- (CGSize)intrinsicContentSize {
    CGFloat buttonsBlockHeight = _filterButtons.count * 30 + (_filterButtons.count > 1 ? _filterButtons.count - 1 : 0) * 8;
    
    return CGSizeMake(
        UIViewNoIntrinsicMetric,
        MAX(buttonsBlockHeight, 100)
    );
}

@end
