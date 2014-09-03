//
//  LSPAudioPlayer.h
//
//  Created by Adam Yanalunas on 3/12/13.
//  Copyright (c) 2013 Amco International Education Services, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LSPAudioPlayer : NSObject

@property (nonatomic, strong) NSURL* previousPath;
@property (nonatomic, readonly, getter = isPlaying) BOOL playing;

+ (LSPAudioPlayer*)sharedInstance;
+ (AVQueuePlayer*)player;

- (CMTime)currentTime;
- (CMTime)duration;
- (void)play;
- (void)playFromURL:(NSURL*)url;
- (void)playFromURLString:(NSString*)url;
- (void)pause;
- (void)resetPlayer;
- (AVPlayerStatus)status;
- (void)stop;
- (CMTime)timeFromProgress:(Float64)progress;
- (void)togglePlayback;

@end
