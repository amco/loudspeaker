//
//  LSPAudioPlayer.m
//
//  Created by Adam Yanalunas on 2/6/14.
//  Copyright (c) 2014 Amco International Education Services, LLC. All rights reserved.
//

#import "LSPAudioView.h"
#import "LSPKit.h"
#import "LSPProgressView.h"
#import <Masonry/Masonry.h>


@interface LSPAudioView ()

- (void)applyConstraints;
- (void)attachSubviews;
- (void)reset;
- (void)setup;

@end


@implementation LSPAudioView


#pragma mark - Lifespan
- (instancetype)initForAutoLayout
{
    self = [super initWithFrame:CGRectZero];
    if (!self) return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self setup];
    
    return self;
}


+ (instancetype)newAutoLayoutView
{
    LSPAudioView *view = [super new];
    if (!view) return nil;
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view setup];
    
    return view;
}


- (void)setup
{
    [self reset];
    
    self.backgroundColor = [UIColor colorWithWhite:238/255. alpha:1];
    
    [self attachSubviews];
    [self applyConstraints];
    [self showLayoutForPlaying:NO];
}


- (void)reset
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


#pragma mark - Layout
- (void)applyConstraints
{
    UIView *progressViewBar = self.progressView.progressBar;
    UIView *progressViewBackground = self.progressView.progressBackground;
    NSDictionary *viewBindings = NSDictionaryOfVariableBindings(_closeButton, _playbackTimeLabel, _playPauseButton, _progressView, progressViewBackground, progressViewBar, _titleLabel);
    
    float horizontalPadding = 12.f;
    float verticalPadding = 12.f;
    NSString *hProgressFormat = [NSString stringWithFormat:@"H:|[_playPauseButton(60)]-%f-[_progressView]-%f-[_closeButton(60)]|", horizontalPadding, horizontalPadding];
    NSArray *horizontalRules = [NSLayoutConstraint constraintsWithVisualFormat:hProgressFormat options:0 metrics:nil views:viewBindings];
    [self addConstraints:horizontalRules];
    
    [self.progressView.progressBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.progressView);
    }];
    
    [_playPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_titleLabel(16)]-8-[_progressView(9)]-15-|" , verticalPadding] options:0 metrics:nil views:viewBindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_playPauseButton]-%f-[_titleLabel]", horizontalPadding] options:0 metrics:nil views:viewBindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_titleLabel]-%f-[_playbackTimeLabel(100)]-%f-[_closeButton]", horizontalPadding, horizontalPadding] options:0 metrics:nil views:viewBindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_playbackTimeLabel]", verticalPadding] options:0 metrics:nil views:viewBindings]];
}


- (void)attachSubviews
{
    [self addSubview:self.closeButton];
    [self addSubview:self.playbackTimeLabel];
    [self addSubview:self.progressView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.playPauseButton];
}


- (void)showLayoutForPlaying:(BOOL)isPlaying
{
    UIImage *icon = (isPlaying ? LSPKit.pauseIcon : LSPKit.playIcon);
    [_playPauseButton setImage:icon forState:UIControlStateNormal];
}


#pragma mark - Properties
- (UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_closeButton setImage:LSPKit.closeIcon forState:UIControlStateNormal];
    }
    
    return _closeButton;
}


- (UILabel *)playbackTimeLabel
{
    if (!_playbackTimeLabel)
    {
        _playbackTimeLabel = [UILabel.alloc initWithFrame:CGRectZero];
        _playbackTimeLabel.adjustsFontSizeToFitWidth = YES;
        _playbackTimeLabel.font = [UIFont fontWithName:LSPKit.fontName size:14.];
        _playbackTimeLabel.textColor = [UIColor colorWithWhite:102/255. alpha:1];
        _playbackTimeLabel.textAlignment = NSTextAlignmentRight;
        _playbackTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _playbackTimeLabel;
}


- (UIButton *)playPauseButton
{
    if (!_playPauseButton)
    {
        _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_playPauseButton setImage:LSPKit.playIcon forState:UIControlStateNormal];
    }
    
    return _playPauseButton;
}


- (LSPProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [LSPProgressView newAutoLayoutView];
        
        [_progressView setForegroundColor:[UIColor colorWithRed:88/255. green:199/255. blue:226/255. alpha:1]];
        [_progressView setBackgroundColor:[UIColor colorWithWhite:207/255. alpha:1]];
    }
    
    return _progressView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel.alloc initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont fontWithName:LSPKit.fontName size:14.];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithWhite:102/255. alpha:1];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _titleLabel;
}

@end
