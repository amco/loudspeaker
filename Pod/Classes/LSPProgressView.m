//
//  LSPProgressView.m
//
//  Created by Adam Yanalunas on 2/12/14.
//  Copyright (c) 2014 Amco International Education Services, LLC. All rights reserved.
//

#import "LSPProgressView.h"
#import <Masonry/Masonry.h>


@interface LSPProgressView ()

- (void)setupViews;

@end


@implementation LSPProgressView


#pragma mark - Lifecycle
- (instancetype)initForAutoLayout
{
    self = [super initWithFrame:CGRectZero];
    if (!self) return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self setup];
    
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initForAutoLayout];
}


+ (instancetype)newAutoLayoutView
{
    LSPProgressView *view = [super new];
    if (!view) return nil;
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view setup];
    
    return view;
}


- (void)setup
{
    [self setupViews];
    [self setForegroundColor:[UIColor colorWithRed:88/255. green:199/255. blue:226/255. alpha:1]];
    [self setBackgroundColor:[UIColor colorWithWhite:207/255. alpha:1]];
}


#pragma mark - Layout
- (void)setupViews
{
    [_progressBackground removeFromSuperview];
    [_progressBar removeFromSuperview];
    
    _progressBackground = nil;
    _progressBar = nil;
    
    [self addSubview:self.progressBackground];
    [self addSubview:self.progressBar];
    
    [self.progressBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (void)setProgress:(Float64)amount
{
    [self.progressBackground layoutIfNeeded];
    CGRect updatedFrame = self.progressBackground.frame;
    updatedFrame.size.width = MIN(CGRectGetWidth(self.progressBackground.frame), CGRectGetWidth(updatedFrame) * amount);
    self.progressBar.frame = updatedFrame;
    
    self.progressBar.accessibilityLabel = [NSString stringWithFormat:@"%i%%", (int) round(updatedFrame.size.width / CGRectGetWidth(self.progressBackground.frame) * 100)];
}


#pragma mark - Properties
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    _progressBackground.backgroundColor = _backgroundColor;
}


- (void)setForegroundColor:(UIColor *)foregroundColor
{
    _foregroundColor = foregroundColor;
    _progressBar.backgroundColor = foregroundColor;
}


- (UIView *)progressBackground
{
    if (!_progressBackground)
    {
        _progressBackground = UIView.new;
        _progressBackground.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _progressBackground;
}


- (UIView *)progressBar
{
    if (!_progressBar)
    {
        _progressBar = UIView.new;
        _progressBar.translatesAutoresizingMaskIntoConstraints = NO;
        
        _progressBar.isAccessibilityElement = YES;
        _progressBar.accessibilityTraits |= UIAccessibilityTraitUpdatesFrequently;
    }
    
    return _progressBar;
}


@end
