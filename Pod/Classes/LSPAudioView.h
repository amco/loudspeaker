//
//  LSPAudioPlayer.h
//
//  Created by Adam Yanalunas on 2/6/14.
//  Copyright (c) 2014 Amco International Education Services, LLC. All rights reserved.
//

@class LSPProgressView;

@interface LSPAudioView : UIView

- (instancetype)initForAutoLayout;
+ (instancetype)newAutoLayoutView;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *playbackTimeLabel;
@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) LSPProgressView *progressView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)showLayoutForPlaying:(BOOL)isPlaying;

@end
