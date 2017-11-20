//
//  LSPAudioPlayer.m
//
//  Created by Adam Yanalunas on 3/12/13.
//  Copyright (c) 2013 Amco International Education Services, LLC. All rights reserved.
//

#import <CoreMedia/CMTime.h>
#import "LSPAudioPlayer.h"

@interface LSPAudioPlayer ()

@property (nonatomic) CMTime seekTolerance;
@property (nonatomic) CMTime observationInterval;

- (void)listenForEndOfAudio:(AVPlayerItem*)audio;

@end

@implementation LSPAudioPlayer


- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _player = AVQueuePlayer.new;
    _observationInterval = CMTimeMake(1, 35);
    _seekTolerance = CMTimeMake(1, 100);
    
    return self;
}


#pragma mark - Playback
- (void)playFromURLString:(NSString*)urlString
{
    NSString *tildeString = [urlString stringByExpandingTildeInPath];
    NSURL *url = [NSURL fileURLWithPath:[tildeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isDirectory:NO];
    [self playFromURL:url];
}

- (void)playFromURL:(NSURL*)path
{
    if (![path.absoluteString isEqualToString:self.previousPath.absoluteString])
    {
        [self pause];
        [self.player removeAllItems];
        
        AVPlayerItem *audioItem = [AVPlayerItem playerItemWithURL:path];
        
        [self listenForEndOfAudio:audioItem];
        [self.player insertItem:audioItem afterItem:nil];
        
        self.previousPath = path;
    }
    
    [self togglePlayback];
}


- (void)play
{
    [self.player play];
}


- (void)pause
{
    [self.player pause];
}


- (void)stop
{
    [self pause];
    [self.player removeAllItems];
    self.previousPath = nil;
}


- (void)setVolume:(float)volume
{
    self.player.volume = volume;
}


- (void)jumpToProgress:(Float64)progress
{
    CMTime time = [self timeFromProgress:progress];
    [self.player seekToTime:time toleranceBefore:self.seekTolerance toleranceAfter:self.seekTolerance];
}


- (void)togglePlayback
{
    if (self.isPlaying)
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}


- (id)addProgressObserver:(void (^)(CMTime time))observer
{
    return [self.player addPeriodicTimeObserverForInterval:self.observationInterval queue:NULL usingBlock:^(CMTime time) {
        observer(time);
    }];
}


- (void)removeProgressObserver:(id)observer
{
    [self.player removeTimeObserver:observer];
}


#pragma mark - Helpers
- (CMTime)currentTime
{
    return self.player.currentItem.currentTime;
}


- (CMTime)duration
{
    return self.player.currentItem.duration;
}


- (AVPlayerStatus)status
{
    return self.player.status;
}


- (BOOL)isPlaying
{
    return (self.player && self.player.rate);
}


- (CMTime)timeFromProgress:(Float64)progress
{
    return CMTimeMakeWithSeconds(CMTimeGetSeconds(self.duration) * progress, 100);
}


- (void)listenForEndOfAudio:(AVPlayerItem*)audio
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    [center addObserver:self selector:@selector(resetPlayer) name:AVPlayerItemDidPlayToEndTimeNotification object:audio];
}

- (void)resetPlayer
{
	if (self.previousPath)
    {
        [NSNotificationCenter.defaultCenter removeObserver:self];
        [self.player removeAllItems];
        self.previousPath = nil;
    }
}

@end
