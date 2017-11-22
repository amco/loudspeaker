//
//  LSPAudioPlayer.h
//
//  Created by Adam Yanalunas on 3/12/13.
//  Copyright (c) 2013 Amco International Education Services, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface LSPAudioPlayer : NSObject

@property (nonatomic, readonly) AVQueuePlayer *player;
@property (nonatomic, nullable) NSURL* previousPath;
@property (nonatomic, readonly, getter = isPlaying) BOOL playing;

- (id)addProgressObserver:(void (^)(CMTime time))observer;
- (CMTime)currentTime;
- (CMTime)duration;
- (void)jumpToProgress:(Float64)progress;
- (void)play;
- (void)playFromURL:(NSURL*)url;
- (void)playFromURLString:(NSString*)url;
- (void)pause;
- (void)removeProgressObserver:(id)observer;
- (void)resetPlayer;
- (void)setVolume:(float)volume;
- (AVPlayerStatus)status;
- (void)stop;
- (CMTime)timeFromProgress:(Float64)progress;
- (void)togglePlayback;

@end


NS_ASSUME_NONNULL_END
