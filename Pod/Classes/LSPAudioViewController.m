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
#import "LSPKit.h"
#import "LSPProgressView.h"


static void * LSPAudioViewControllerContext = &LSPAudioViewControllerContext;


@interface LSPAudioViewController ()

@property (nonatomic, weak) LSPAudioPlayer *player;
@property (nonatomic, weak) AVQueuePlayer *audioQueuePlayer;
@property (nonatomic) BOOL playing;
@property (nonatomic, strong) id progressObserver;

- (void)addTimeObserver;
- (void)closeButtonPressed:(UIButton *)button;
- (void)handleTimelineTap:(UITapGestureRecognizer *)gesture;
- (void)playedUntilEnd:(NSNotification *)notificaiton;
- (void)removeTimeObserver;
- (void)showProgress;
- (void)togglePlayPause:(UIButton *)button;
- (void)updateProgress;
- (void)updateTimeLabel;

@end


@implementation LSPAudioViewController

@dynamic view;

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    [self setup];
    
    return self;
}


+ (instancetype)new
{
    LSPAudioViewController *audioVC = [self.class.alloc init];
    if (!audioVC) return nil;
    
    return audioVC;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)setup
{
    self.view = [LSPAudioView newAutoLayoutView];
    [self.view.closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.playPauseButton addTarget:self action:@selector(togglePlayPause:) forControlEvents:UIControlEventTouchUpInside];
    
    self.player = LSPAudioPlayer.sharedInstance;
    self.audioQueuePlayer = LSPAudioPlayer.player;
    
    // Every .35 of a second.
    self.observationInterval = CMTimeMake(1, 35);
    
    [self addObserver:self forKeyPath:@"playing" options:0 context:&LSPAudioViewControllerContext];
    
    UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(handleTimelineTap:)];
    [self.view.progressView addGestureRecognizer:tapGesture];
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
    _URL = nil;
    _playing = NO;
    _player = nil;
    _audioQueuePlayer = nil;
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == LSPAudioViewControllerContext)
    {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(playing))])
        {
            [self.view showLayoutForPlaying:self.player.isPlaying];
        }
    }
}


#pragma mark - Layout
- (void)assignConstraintsToView:(UIView *)parentView
{
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:60];
    [self.view addConstraint:heightConstraint];
    
    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [parentView addConstraint:self.bottomConstraint];
    
    UIView *view = self.view;
    NSDictionary *viewBindings = NSDictionaryOfVariableBindings(view);
    [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:viewBindings]];
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
    [LSPAudioPlayer.sharedInstance stop];
    DELEGATE_SAFELY(self.delegate, @selector(audioViewController:didStopPlayer:), [self.delegate audioViewController:self didStopPlayer:self.player];)
}


- (void)playedUntilEnd:(NSNotification *)notificaiton
{
    self.playing = NO;
    [self.view showLayoutForPlaying:NO];
    [self.view.progressView setProgress:0];
    [self close];
}


#pragma mark - Actions

- (void)playAudioWithURL:(NSURL *)url
{
    NSDictionary *userInfo = @{ @"url": url };
    [[NSNotificationCenter defaultCenter] postNotificationName:LSPAudioPlayerStart object:self userInfo:userInfo];
    [LSPAudioPlayer.sharedInstance playFromURL:url];
    [self playAudioSetupWithURL:url];
}

- (void)playAudioSetupWithURL:(NSURL *)url
{
    self.URL = url;
    self.title = url.lastPathComponent;
    
    self.playing = self.player.isPlaying;
    
    [self.view.progressView setProgress:0];
    [self showProgress];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    [nc addObserver:self selector:@selector(playedUntilEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)close
{
    DELEGATE_SAFELY(self.delegate, @selector(audioViewController:willClosePlayer:), [self.delegate audioViewController:self willClosePlayer:self.player];)
    [self.player stop];
    DELEGATE_SAFELY(self.delegate, @selector(audioViewController:didClosePlayer:), [self.delegate audioViewController:self didClosePlayer:self.player];)
}


- (void)closeButtonPressed:(UIButton *)button
{
    [self close];
}


- (void)togglePlayPause:(UIButton *)button
{
    if (self.isPlaying)
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
    [self updateProgress];
    [self updateTimeLabel];
}


- (void)updateProgress
{
    if (self.player.status != AVPlayerStatusReadyToPlay) return;
    
    Float64 duration = CMTimeGetSeconds(self.player.duration);
    Float64 current = CMTimeGetSeconds(self.player.currentTime);
    
    if (!isnormal(duration)) return;
    
    Float64 progress = (current / duration);
    [self.view.progressView setProgress:progress];
}


- (void)updateTimeLabel
{
    NSString *duration = [LSPCMTimeHelper readableCMTime:self.player.duration];
    NSString *current = [LSPCMTimeHelper readableCMTime:self.player.currentTime];
    NSString *labelText = [NSString stringWithFormat:@"%@ / %@", current, duration];
    
    self.view.playbackTimeLabel.text = labelText;
}


#pragma mark - Helpers
- (void)addTimeObserver
{
    __weak __typeof(self)weakself = self;
    _progressObserver = [self.audioQueuePlayer addPeriodicTimeObserverForInterval:self.observationInterval queue:NULL usingBlock:^(CMTime time) {
        [weakself showProgress];
    }];
}


- (void)removeTimeObserver
{
    if (!_progressObserver) return;
    
    [self.audioQueuePlayer removeTimeObserver:_progressObserver];
    _progressObserver = nil;
}


#pragma mark - Gestures
- (void)handleTimelineTap:(UITapGestureRecognizer *)gesture
{
    BOOL validTap = (gesture.state == UIGestureRecognizerStateEnded && self.view.progressView.hidden == NO);
    if (validTap)
    {
        CGPoint location = [gesture locationOfTouch:0 inView:self.view.progressView];
        float xPos = location.x;
        Float64 jumpPoint = xPos/CGRectGetWidth(self.view.progressView.frame);
        CMTime jumpTime = [self.player timeFromProgress:jumpPoint];
        [self.audioQueuePlayer seekToTime:jumpTime toleranceBefore:self.seekTolerance toleranceAfter:self.seekTolerance];
        [self updateProgress];
    }
}


#pragma mark - Properties
- (BOOL)isPlaying
{
    return self.player.isPlaying;
}


- (CMTime)seekTolerance
{
    if (CMTimeCompare(_seekTolerance, kCMTimeInvalid) == 0)
    {
        _seekTolerance = CMTimeMake(1, 100);
    }
    
    return _seekTolerance;
}


- (void)setURL:(NSURL *)URL
{
    [self removeTimeObserver];
    _URL = URL;
    [self addTimeObserver];
}


- (NSString *)title
{
    return self.view.titleLabel.text;
}


- (void)setTitle:(NSString *)title
{
    self.view.titleLabel.text = title;
}


@end
