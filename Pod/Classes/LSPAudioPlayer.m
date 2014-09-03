//
//  LSPAudioPlayer.m
//
//  Created by Adam Yanalunas on 3/12/13.
//  Copyright (c) 2013 Amco International Education Services, LLC. All rights reserved.
//

#import <CoreMedia/CMTime.h>
#import "LSPAudioPlayer.h"

@interface LSPAudioPlayer ()

- (void)listenForEndOfAudio:(AVPlayerItem*)audio;

@end

@implementation LSPAudioPlayer

static dispatch_once_t instanceToken = 0;
static dispatch_once_t playerToken = 0;
__strong static id _sharedObject = nil;
__strong static AVQueuePlayer* _player;

+ (LSPAudioPlayer*)sharedInstance
{
    dispatch_once(&instanceToken, ^{
        _sharedObject = [self.class.alloc init];
    });
    return _sharedObject;
}

+ (AVQueuePlayer*)player
{
    dispatch_once(&playerToken, ^{
        _player = AVQueuePlayer.new;
        _player.muted = YES;
    });
    return _player;
}


#pragma mark - Playback
- (void)playFromURLString:(NSString*)urlString
{
    NSString* tildeString = [urlString stringByExpandingTildeInPath];
    NSURL* url = [NSURL fileURLWithPath:[tildeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isDirectory:NO];
    [self playFromURL:url];
}

- (void)playFromURL:(NSURL*)path
{
    if (![path.absoluteString isEqualToString:self.previousPath.absoluteString])
    {
        [self pause];
        [self.class.player removeAllItems];
        
        AVPlayerItem* audioItem = [AVPlayerItem playerItemWithURL:path];
        
        [self listenForEndOfAudio:audioItem];
        [self.class.player insertItem:audioItem afterItem:nil];
        
        self.previousPath = path;
    }
    
    [self togglePlayback];
}


- (void)play
{
    [self.class.player play];
}


- (void)pause
{
    [self.class.player pause];
}


- (void)stop
{
    [self pause];
    [self.class.player removeAllItems];
    self.previousPath = nil;
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


#pragma mark - Helpers
- (CMTime)currentTime
{
    return self.class.player.currentItem.currentTime;
}


- (CMTime)duration
{
    return self.class.player.currentItem.duration;
}


- (AVPlayerStatus)status
{
    return self.class.player.status;
}


- (BOOL)isPlaying
{
    return (self.class.player && self.class.player.rate);
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
        [self.class.player removeAllItems];
        self.previousPath = nil;
    }
}

@end
