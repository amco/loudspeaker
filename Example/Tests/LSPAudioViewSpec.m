//
//  LSPAudioViewSpec.m
//  Tests
//
//  Created by Adam Yanalunas on 11/20/17.
//  Copyright © 2017 Adam Yanalunas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <loudspeaker/loudspeaker.h>


SpecBegin(LSPAudioView)


describe(@"initForAutoLayout", ^{
    __block LSPAudioView *view;
    
    beforeEach(^{
        view = [LSPAudioView.alloc initForAutoLayout];
    });
    
    it(@"sets view to disable autoresize mask", ^{
        expect(view.translatesAutoresizingMaskIntoConstraints).to.beFalsy();
    });
    
    it(@"provides a default background color", ^{
        UIColor *bgColor = [UIColor colorWithWhite:238/255. alpha:1];
        expect(view.backgroundColor).to.equal(bgColor);
    });
    
    it(@"configures the view", ^{
        expect(view.closeButton.superview).to.beIdenticalTo(view);
        expect(view.playbackTimeLabel.superview).to.beIdenticalTo(view);
        expect(view.playPauseButton.superview).to.beIdenticalTo(view);
        expect(view.progressView.superview).to.beIdenticalTo(view);
        expect(view.titleLabel.superview).to.beIdenticalTo(view);
    });
});

describe(@"setCurrentProgress:forDuration:", ^{
    __block LSPAudioView *view;
    
    beforeEach(^{
        view = LSPAudioView.newAutoLayoutView;
        [view setCurrentProgress:@"123" forDuration:@"456"];
    });
    
    it(@"formats the progress text", ^{
        expect(view.playbackTimeLabel.text).to.equal(@"123 / 456");
    });
    
    it(@"applies an updated acessibility label", ^{
        expect(view.playbackTimeLabel.accessibilityLabel).to.equal(@"123 seconds elapsed");
    });
});

describe(@"showLayoutForPlaying:", ^{
    __block LSPAudioView *view;
    
    beforeEach(^{
        view = LSPAudioView.newAutoLayoutView;
    });
    
    context(@"play", ^{
        beforeEach(^{
            [view showLayoutForPlaying:NO];
        });
        
        it(@"shows the play button", ^{
            UIImage *actual = [view.playPauseButton imageForState:UIControlStateNormal];
            expect(actual).to.equal(LSPKit.playIcon);
        });
        
        it(@"applies accessibility information", ^{
            expect(view.playPauseButton.accessibilityLabel).to.equal(@"Play");
            expect(view.playPauseButton.accessibilityHint).to.equal(@"Tap to resume playback");
        });
    });
    
    context(@"pause", ^{
        beforeEach(^{
            [view showLayoutForPlaying:YES];
        });
        
        it(@"shows the pause button", ^{
            UIImage *actual = [view.playPauseButton imageForState:UIControlStateNormal];
            expect(actual).to.equal(LSPKit.pauseIcon);
        });
        
        it(@"applies accessibility information", ^{
            expect(view.playPauseButton.accessibilityLabel).to.equal(@"Pause");
            expect(view.playPauseButton.accessibilityHint).to.equal(@"Tap to pause playback");
        });
    });
});


SpecEnd
