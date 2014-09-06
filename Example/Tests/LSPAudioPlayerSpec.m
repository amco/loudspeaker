//
//  LSPAudioPlayerSpec.m
//  LSPAudioPlayerSpec
//
//  Created by Adam Yanalunas on 08/29/2014.
//  Copyright (c) 2014 Adam Yanalunas. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMTime.h>
#import "LSPAudioPlayer.h"
#import <OCMock/OCMock.h>


#define SETUP_AND_RESET_PLAYER \
__block LSPAudioPlayer* player = LSPAudioPlayer.sharedInstance;\
\
afterEach(^{\
[player resetPlayer];\
});\
\
afterAll(^{\
player = nil;\
});


SpecBegin(LSPAudioPlayerSpec)

context(@"LSPAudioPlayer", ^{
    __block NSURL* audioFile1 = nil;
    __block NSURL* audioFile2 = nil;
    
    beforeAll(^{
        audioFile1 = [NSBundle.mainBundle URLForResource:@"Nyan-Cat" withExtension:@"mp3"];
        audioFile2 = [[NSBundle bundleForClass:self.class] URLForResource:@"Nyan-Cat-Test" withExtension:@"mp3"];
    });
    
    describe(@"sharedInstance", ^{
        it(@"Returns the same instance", ^{
            LSPAudioPlayer* player1 = LSPAudioPlayer.sharedInstance;
            LSPAudioPlayer* player2 = LSPAudioPlayer.sharedInstance;
            
            expect(player1).to.beIdenticalTo(player2);
            
            player1 = nil;
            player2 = nil;
        });
    });
    
    describe(@"playFromURLString:", ^{
        __block LSPAudioPlayer* player = LSPAudioPlayer.sharedInstance;
        __block OCMockObject *playerMock;
        __block NSString* file = @"~/Documents/banana.mp3";
        
        beforeEach(^{
            playerMock = OCMPartialMock(player);
        });
        
        afterEach(^{
            [playerMock stopMocking];
            [player resetPlayer];
        });
        
        afterAll(^{
            player = nil;
        });
        
        it(@"transforms a URL-like string into a NSURL, calling configureWithURL", ^{
            NSString* tildeString = [file stringByExpandingTildeInPath];
            NSURL* expectedUrl = [NSURL fileURLWithPath:[tildeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isDirectory:NO];
            
            [[playerMock expect] playFromURL:expectedUrl];
            
            [player playFromURLString:file];
        });
    });
    
    describe(@"playFromURL:", ^{
        __block LSPAudioPlayer* player = LSPAudioPlayer.sharedInstance;
        
        afterEach(^{
            [player resetPlayer];
        });
        
        afterAll(^{
            player = nil;
        });
        
        it(@"immediately starts playing file if it is not the previously-called file", ^{
            AVQueuePlayer* queuePlayer = LSPAudioPlayer.player;
            
            expect(queuePlayer.items).to.beEmpty();
            
            [player playFromURL:audioFile1];
            
            expect(queuePlayer.items).to.haveCountOf(1);
            expect([(AVURLAsset *)[queuePlayer.items[0] asset] URL]).to.equal(audioFile1);
        });
        
        it(@"doesn't create a new item when called again with the previous file", ^{
            AVQueuePlayer* queuePlayer = LSPAudioPlayer.player;
            
            [player playFromURL:audioFile1];
            expect(queuePlayer.items).to.haveCountOf(1);
            
            [player playFromURL:audioFile1];
            expect(queuePlayer.items).to.haveCountOf(1);
        });
        
        it(@"should toggle playback", ^{
            [player playFromURL:audioFile1];
            
            expect(player.isPlaying).to.beTruthy();
        });

        it(@"sets up a new file to play if it is different than the last", ^{
            AVQueuePlayer* queuePlayer = LSPAudioPlayer.player;
            
            [player playFromURL:audioFile1];
            NSURL* oldPath = player.previousPath;
            
            [queuePlayer pause];
            
            [player playFromURL:audioFile2];
            NSURL* newPath = audioFile2;
            
            AVPlayerItem* track = [queuePlayer.items objectAtIndex:0];
            expect(track.asset.tracks).to.haveCountOf(1);
            expect(player.previousPath).to.equal(newPath);
            expect(player.previousPath).toNot.equal(oldPath);
        });
    });
    
    
    describe(@"play", ^{
        SETUP_AND_RESET_PLAYER
        
        it(@"should play the current track", ^{
            [player play];
            expect(player.isPlaying).to.beTruthy();
        });
    });
    
    
    describe(@"pause", ^{
        SETUP_AND_RESET_PLAYER
        
        it(@"should pause the current track", ^{
            [player pause];
            expect(player.isPlaying).to.beFalsy();
        });
    });
    
    
    describe(@"stop", ^{
        SETUP_AND_RESET_PLAYER
        
        __block AVQueuePlayer* queuePlayer = LSPAudioPlayer.player;
        
        beforeAll(^{
            queuePlayer = LSPAudioPlayer.player;
        });
        
        beforeEach(^{
            [player playFromURL:audioFile1];
        });
        
        afterAll(^{
            queuePlayer = nil;
        });
        
        it(@"should remove any queued items", ^{
            expect(queuePlayer.items).to.haveCountOf(1);
            
            [player stop];
            
            expect(queuePlayer.items).to.haveCountOf(0);
        });
        
        it(@"should forget the last track played", ^{
            expect(player.previousPath).to.equal(audioFile1);
            
            [player stop];
            
            expect(player.previousPath).to.beNil();
        });
    });
    
    
    describe(@"togglePlayback", ^{
        SETUP_AND_RESET_PLAYER
        
        it(@"should pause playback if currently playing", ^{
            [player pause];
            [player togglePlayback];
            expect(player.isPlaying).to.beTruthy();
        });
        
        it(@"should resume playback if currently paused", ^{
            [player play];
            [player togglePlayback];
            expect(player.isPlaying).to.beFalsy();
        });
    });
    
    
    describe(@"currentTime", ^{
        __block CMTime destinationTime;
        
        SETUP_AND_RESET_PLAYER
        
        beforeEach(^{
            [player playFromURL:audioFile1];
            
            AVQueuePlayer *queuePlayer = LSPAudioPlayer.player;
            destinationTime = [player timeFromProgress:.5];
            CMTime seekTolerance = CMTimeMake(1, 100);
            [queuePlayer seekToTime:destinationTime toleranceBefore:seekTolerance toleranceAfter:seekTolerance];
        });
        
        it(@"should return the elapsed time of the current track", ^{
            expect(CMTIME_COMPARE_INLINE(player.currentTime, ==, destinationTime)).to.beTruthy();
        });
    });
    
    
    describe(@"duration", ^{
        __block CMTime durationTime;
        
        SETUP_AND_RESET_PLAYER
        
        beforeEach(^{
            [player playFromURL:audioFile1];
            AVQueuePlayer *queuePlayer = LSPAudioPlayer.player;
            durationTime = queuePlayer.currentItem.duration;
        });
        
        it(@"should return the duration of the current track", ^{
            expect(CMTIME_COMPARE_INLINE(player.duration, ==, durationTime)).to.beTruthy();
        });
    });
    

    describe(@"status", ^{
        SETUP_AND_RESET_PLAYER
        
        beforeEach(^{
            [player playFromURL:audioFile1];
        });
        
        it(@"should return the player's current playback status", ^{
            AVQueuePlayer *queuePlayer = LSPAudioPlayer.player;
            expect(player.status).to.equal(queuePlayer.status);
        });
    });
    
    
    describe(@"isPlaying", ^{
        SETUP_AND_RESET_PLAYER
        
        beforeEach(^{
            [player playFromURL:audioFile1];
        });
        
        it(@"should return YES if audio is determined to be playing", ^{
            [player play];
            expect(player.isPlaying).to.beTruthy();
        });
        
        it(@"should return NO if audio is determined to be paused or stopped", ^{
            [player pause];
            expect(player.isPlaying).to.beFalsy();
            
            [player play];
            expect(player.isPlaying).to.beTruthy();
            
            [player stop];
            expect(player.isPlaying).to.beFalsy();
        });
    });
    
    
    describe(@"timeForProgress:", ^{
        SETUP_AND_RESET_PLAYER
        
        beforeEach(^{
            // 30 seconds
            CMTime duration = CMTimeMake(30, 1);
            player = OCMPartialMock(player);
            OCMStub(player.duration).andReturn(duration);
        });
        
        afterEach(^{
            [(OCMockObject *)player stopMocking];
        });
        
        it(@"should return a time for the current track based on a 0-1 progress through the track", ^{
            CMTime halfway = [player timeFromProgress:.5];
            Float64 halfwaySeconds = CMTimeGetSeconds(halfway);
            expect(halfwaySeconds).to.equal(15.);
            
            CMTime threeQuarters = [player timeFromProgress:.75];
            Float64 threeQuartersSeconds = CMTimeGetSeconds(threeQuarters);
            expect(threeQuartersSeconds).to.equal(22.5);
        });
    });
    
    
    describe(@"resetPlayer", ^{
        __block OCMockObject *ncStub;
        __block LSPAudioPlayer* player = LSPAudioPlayer.sharedInstance;
        
        beforeEach(^{
            ncStub = OCMPartialMock(NSNotificationCenter.defaultCenter);
        });
        
        afterAll(^{
            player = nil;
        });
        
        afterEach(^{
            [player resetPlayer];
            [ncStub stopMocking];
        });
        
        it(@"removes observers if previousPath is not nil", ^{
            player.previousPath = audioFile1;
            
            [[ncStub expect] removeObserver:player];
            [player resetPlayer];
            [ncStub verify];
        });
        
        it(@"doesn't remove observers if previousPath is nil", ^{
            player.previousPath = nil;
            
            [[ncStub reject] removeObserver:player];
            [player resetPlayer];
            [ncStub verify];
        });
        
        it(@"removes items from queue if previousPath is not nil", ^{
            player.previousPath = audioFile1;
            
            AVPlayerItem* item = [AVPlayerItem playerItemWithURL:audioFile1];
            
            AVQueuePlayer* queuePlayer = LSPAudioPlayer.player;
            [queuePlayer insertItem:item afterItem:nil];
            
            expect(queuePlayer.items).to.haveCountOf(1);
            [player resetPlayer];
            expect(queuePlayer.items).to.haveCountOf(0);
        });
        
        it(@"does not remove items from queue if previousPath is nil", ^{
            player.previousPath = audioFile1;
            
            AVPlayerItem* item = [AVPlayerItem playerItemWithURL:audioFile1];
            
            AVQueuePlayer* queuePlayer = LSPAudioPlayer.player;
            [queuePlayer insertItem:item afterItem:nil];
            [queuePlayer pause];
            
            expect(queuePlayer.items).to.haveCountOf(1);
            player.previousPath = nil;
            [player resetPlayer];
            expect(queuePlayer.items).to.haveCountOf(1);
        });
        
        it(@"nils out the previousPath", ^{
            player.previousPath = [NSURL URLWithString:@"http://foo.com"];
            
            [player resetPlayer];
            
            expect(player.previousPath).to.beNil();
        });
    });
});


SpecEnd
