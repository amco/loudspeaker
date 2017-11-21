//
//  LSPAudioViewController.m
//
//  Created by Adam Yanalunas on 2/6/14.
//  Copyright (c) 2014 Amco International Education Services, LLC. All rights reserved.
//

#import "LSPAudioPlayer.h"
#import "LSPAudioView.h"
#import "LSPAudioViewController.h"
#import "LSPCMTimeHelper.h"
#import "LSPConfiguration.h"
#import "LSPKit.h"
#import "LSPProgressView.h"
#import <Masonry/Masonry.h>


static void * LSPAudioViewControllerContext = &LSPAudioViewControllerContext;


@interface LSPAudioViewController ()

@property (nonatomic) LSPAudioPlayer *player;
@property (nonatomic) MASConstraint *bottomConstraint;
@property (nonatomic) LSPConfiguration *configuration;
@property (nonatomic) LSPAudioView *playerView;
@property (nonatomic) BOOL playing;
@property (nonatomic) id progressObserver;

- (void)addTimeObserver;
- (MASViewAttribute *)bottomLayout;
- (CGFloat)bottomOffset;
- (void)closeButtonPressed:(UIButton *)button;
- (void)handleTimelineTap:(UITapGestureRecognizer *)gesture;
- (void)playedUntilEnd:(NSNotification *)notificaiton;
- (Float64)progressFromGesture:(UIGestureRecognizer *)gesture;
- (void)removeTimeObserver;
- (void)showProgress;
- (void)togglePlayPause:(UIButton *)button;
- (void)updateProgress;
- (void)updateTimeLabel;

@end


@implementation LSPAudioViewController

@dynamic view;

#pragma mark - Lifecycle
- (instancetype)initWithConfiguration:(LSPConfiguration *)configuration
{
    self = [super init];
    if (!self) return nil;

    _configuration = configuration;
    _model = LSPAudioPlayerModel.new;
    _player = LSPAudioPlayer.new;
    _playerView = [LSPAudioView newAutoLayoutView];
    [_player setVolume:_configuration.volume];

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.playerView];
    [self assignConstraintsToView];
    
    [self.playerView.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerView.playPauseButton addTarget:self action:@selector(togglePlayPause:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(handleTimelineTap:)];
    [self.playerView.progressView addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [UIPanGestureRecognizer.alloc initWithTarget:self action:@selector(handleTimelinePan:)];
    [self.playerView.progressView addGestureRecognizer:panGesture];

    [self addObserver:self forKeyPath:@"playing" options:0 context:&LSPAudioViewControllerContext];
}


- (void)reset
{
    [self stop];
    [self removeTimeObserver];
    
    @try
    {
        [self removeObserver:self forKeyPath:@"playing" context:&LSPAudioViewControllerContext];
    }
    @catch (NSException * __unused exception) {}
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.view.superview)
    {
        [self.view removeFromSuperview];
    }

    if (self.parentViewController)
    {
        [self removeFromParentViewController];
    }
    
    _delegate = nil;
    _playing = NO;
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == LSPAudioViewControllerContext)
    {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(playing))])
        {
            [self.playerView showLayoutForPlaying:self.player.isPlaying];
        }
    }
}


#pragma mark - Layout
- (void)assignConstraintsToView
{
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(self.view);
        make.bottom.equalTo(self.bottomLayout);
    }];
    [self.view layoutIfNeeded];
}


- (void)show
{
    CGFloat offset = [self bottomOffset];
    [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomLayout).with.offset(offset);
    }];
    [self.view layoutIfNeeded];
    
    NSTimeInterval duration = .666f;
    NSTimeInterval delay = 0;
    UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut);
    
    [UIView animateWithDuration:duration delay:delay options:options animations:^{
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomLayout).with.offset(0);
        }];
        [self.view layoutIfNeeded];
    } completion:nil];
}


- (void)hide:(void (^)(void))completion
{
    [self.view layoutIfNeeded];
    
    NSTimeInterval duration = .666f;
    NSTimeInterval delay = 0;
    UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut);
    
    CGFloat offset = [self bottomOffset];
    [UIView animateWithDuration:duration delay:delay options:options animations:^{
        [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomLayout).with.offset(offset);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    }];
}


- (void)viewWillLayoutSubviews
{
    [self showProgress];
}


#pragma mark - Playback controls
- (void)play
{
    DELEGATE_SAFELY(self.delegate, @selector(audioViewController:willPlayPlayer:), [self.delegate audioViewController:self willPlayPlayer:self.player];)
    
    [self removeTimeObserver];
    [self.player play];
    [self addTimeObserver];
    
    DELEGATE_SAFELY(self.delegate, @selector(audioViewController:didPlayPlayer:), [self.delegate audioViewController:self didPlayPlayer:self.player];)
}


- (void)pause
{
    DELEGATE_SAFELY(self.delegate, @selector(audioViewController:willPausePlayer:), [self.delegate audioViewController:self willPausePlayer:self.player];)
    [self removeTimeObserver];
    [self.player pause];
    DELEGATE_SAFELY(self.delegate, @selector(audioViewController:didPausePlayer:), [self.delegate audioViewController:self didPausePlayer:self.player];)
}


- (void)stop
{
    DELEGATE_SAFELY(self.delegate, @selector(audioViewController:willStopPlayer:), [self.delegate audioViewController:self willStopPlayer:self.player];)
    [[NSNotificationCenter defaultCenter] postNotificationName:LSPAudioPlayerStop object:self];
    [self.player stop];
    DELEGATE_SAFELY(self.delegate, @selector(audioViewController:didStopPlayer:), [self.delegate audioViewController:self didStopPlayer:self.player];)
}


- (void)playedUntilEnd:(NSNotification *)notificaiton
{
    self.playing = NO;
    [self.playerView showLayoutForPlaying:NO];
    [self.playerView.progressView setProgress:0];
    [self close];
}


#pragma mark - Actions

- (void)playAudioWithURL:(NSURL *)url
{
    NSDictionary *userInfo = @{ @"url": url };
    [[NSNotificationCenter defaultCenter] postNotificationName:LSPAudioPlayerStart object:self userInfo:userInfo];
    [self.player playFromURL:url];
    [self playAudioSetupWithURL:url];
}

- (void)playAudioSetupWithURL:(NSURL *)url
{
    [self removeTimeObserver];
    [self.model setDestination:url];
    [self addTimeObserver];
    self.playerView.titleLabel.text = self.model.title;
    
    self.playing = self.player.isPlaying;
    
    [self.playerView.progressView setProgress:0];
    [self showProgress];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    [nc addObserver:self selector:@selector(playedUntilEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)close
{
    DELEGATE_SAFELY(self.delegate, @selector(audioViewController:willClosePlayer:), [self.delegate audioViewController:self willClosePlayer:self.player];)
    [self.player stop];
    [self hide:^{
        DELEGATE_SAFELY(self.delegate, @selector(audioViewController:didClosePlayer:), [self.delegate audioViewController:self didClosePlayer:self.player];)
        [self reset];
    }];
}


- (void)closeButtonPressed:(UIButton *)button
{
    [self close];
}


- (void)togglePlayPause:(UIButton *)button
{
    if (self.player.isPlaying)
    {
        [self pause];
    }
    else
    {
        [self play];
    }
    
    self.playing = self.player.isPlaying;
}


#pragma mark - Progress
- (void)showProgress
{
    if (self.player.status != AVPlayerStatusReadyToPlay) return;
    
    [self updateProgress];
    [self updateTimeLabel];
}


- (void)updateProgress
{
    Float64 duration = CMTimeGetSeconds(self.player.duration);
    Float64 current = CMTimeGetSeconds(self.player.currentTime);
    
    if (!isnormal(duration)) return;
    
    Float64 progress = (current / duration);
    [self.playerView.progressView setProgress:progress];
}


- (void)updateTimeLabel
{
    NSString *duration = [LSPCMTimeHelper readableCMTime:self.player.duration];
    NSString *current = [LSPCMTimeHelper readableCMTime:self.player.currentTime];
    [self.playerView setCurrentProgress:current forDuration:duration];
}


- (void)jumpToProgress:(Float64)progress
{
    [self.player jumpToProgress:progress];
    [self showProgress];
}


#pragma mark - Helpers
- (void)addTimeObserver
{
    __weak __typeof(self)weakself = self;
    [self.player addProgressObserver:^(CMTime time) {
        [weakself showProgress];
    }];
}


- (void)removeTimeObserver
{
    if (!_progressObserver) return;
    
    [self.player removeProgressObserver:_progressObserver];
    _progressObserver = nil;
}


- (BOOL)isPlaying
{
    return self.player.isPlaying;
}


- (CGFloat)bottomOffset
{
    CGFloat safeAreaInset = 0;
    if (@available(iOS 11, *))
    {
        safeAreaInset = self.view.safeAreaInsets.bottom;
    }
    return safeAreaInset + CGRectGetHeight(self.playerView.frame);
}


- (MASViewAttribute *)bottomLayout
{
    MASViewAttribute *bottom = self.view.mas_bottom;
    if (@available(iOS 11, *))
    {
        bottom = self.view.mas_safeAreaLayoutGuideBottom;
    }
    
    return bottom;
}


#pragma mark - Gestures
- (void)handleTimelineTap:(UITapGestureRecognizer *)gesture
{
    BOOL validTap = (gesture.state == UIGestureRecognizerStateEnded && self.playerView.progressView.hidden == NO);
    if (validTap)
    {
        Float64 progress = [self progressFromGesture:gesture];
        [self jumpToProgress:progress];
    }
}


// TODO: Pause while scrubbing, play when gesture is done
- (void)handleTimelinePan:(UIPanGestureRecognizer *)gesture
{
    BOOL validPan = (gesture.state == UIGestureRecognizerStateChanged && self.playerView.progressView.hidden == NO);
    if (validPan)
    {
        Float64 progress = [self progressFromGesture:gesture];
        [self jumpToProgress:progress];
    }
}


- (Float64)progressFromGesture:(UIGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationOfTouch:0 inView:self.playerView.progressView];
    CGFloat xPos = location.x;
    return (Float64)xPos/CGRectGetWidth(self.playerView.progressView.frame);
}


@end
