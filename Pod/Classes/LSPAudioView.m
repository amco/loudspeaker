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
    float horizontalPadding = 12.f;
    float verticalPadding = 12.f;
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playPauseButton.mas_right).offset(horizontalPadding);
        make.right.greaterThanOrEqualTo(_closeButton.mas_left).offset(-horizontalPadding);
        make.top.equalTo(_titleLabel.mas_bottom).offset(6);
        make.height.equalTo(@9);
    }];
    
    [_playPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.and.height.equalTo(@60);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
        make.width.and.height.equalTo(@60);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(verticalPadding);
        make.right.greaterThanOrEqualTo(_playbackTimeLabel.mas_left).offset(horizontalPadding);
        make.left.equalTo(_playPauseButton.mas_right).offset(horizontalPadding);
    }];
    
    [_playbackTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.right.greaterThanOrEqualTo(_closeButton.mas_left).offset(-horizontalPadding);
        make.top.greaterThanOrEqualTo(self.mas_top).offset(verticalPadding);
    }];
}


- (void)attachSubviews
{
    [self addSubview:self.closeButton];
    [self addSubview:self.playbackTimeLabel];
    [self addSubview:self.progressView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.playPauseButton];
}


#pragma mark - Playback information
- (void)showLayoutForPlaying:(BOOL)isPlaying
{
    UIImage *icon = (isPlaying ? LSPKit.pauseIcon : LSPKit.playIcon);
    [_playPauseButton setImage:icon forState:UIControlStateNormal];
    [self setAccessibilityForPlayback:isPlaying];
}


- (void)setCurrentProgress:(NSString *)progress forDuration:(NSString *)duration
{
    NSString *labelText = [NSString stringWithFormat:@"%@ / %@", progress, duration];
    
    self.playbackTimeLabel.text = labelText;
    self.playbackTimeLabel.accessibilityLabel = [NSString stringWithFormat:[LSPKit localizedString:@"loudspeaker.seconds_elapsed_format"], progress];
}


#pragma mark - Helpers
- (void)setAccessibilityForPlayback:(BOOL)isPlaying
{
    if (isPlaying)
    {
        _playPauseButton.accessibilityLabel = [LSPKit localizedString:@"loudspeaker.pause"];
        _playPauseButton.accessibilityHint = [LSPKit localizedString:@"loudspeaker.tap_to_pause_playback"];
    }
    else
    {
        _playPauseButton.accessibilityLabel = [LSPKit localizedString:@"loudspeaker.play"];
        _playPauseButton.accessibilityHint = [LSPKit localizedString:@"loudspeaker.tap_to_resume_playback"];
    }
}


#pragma mark - Properties
- (UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_closeButton setImage:LSPKit.closeIcon forState:UIControlStateNormal];
        
        _closeButton.isAccessibilityElement = YES;
        _closeButton.accessibilityLabel = [LSPKit localizedString:@"loudspeaker.close"];
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
        
        _playbackTimeLabel.isAccessibilityElement = YES;
        _playbackTimeLabel.accessibilityTraits |= UIAccessibilityTraitUpdatesFrequently;
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
        
        _playPauseButton.isAccessibilityElement = YES;
        [self setAccessibilityForPlayback:NO];
    }
    
    return _playPauseButton;
}


- (LSPProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [LSPProgressView newAutoLayoutView];
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
        
        _titleLabel.isAccessibilityElement = YES;
    }
    
    return _titleLabel;
}

@end
