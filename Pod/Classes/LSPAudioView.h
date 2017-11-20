//
//  LSPAudioPlayer.h
//
//  Created by Adam Yanalunas on 2/6/14.
//  Copyright (c) 2014 Amco International Education Services, LLC. All rights reserved.
//


#import "LSPProgressView.h"


NS_ASSUME_NONNULL_BEGIN


@interface LSPAudioView : UIView

- (instancetype)initForAutoLayout NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)newAutoLayoutView;

@property (nonatomic) UIButton *closeButton;
@property (nonatomic) UILabel *playbackTimeLabel;
@property (nonatomic) UIButton *playPauseButton;
@property (nonatomic) LSPProgressView *progressView;
@property (nonatomic) UILabel *titleLabel;

- (void)setCurrentProgress:(NSString *)progress forDuration:(NSString *)duration;
- (void)showLayoutForPlaying:(BOOL)isPlaying;

@end


NS_ASSUME_NONNULL_END
