//
//  LSPAudioViewController.h
//
//  Created by Adam Yanalunas on 2/6/14.
//  Copyright (c) 2014 Amco International Education Services, LLC. All rights reserved.
//

#import <CoreMedia/CMTime.h>
#import "LSPAudioView.h"

@class LSPAudioPlayer, LSPAudioViewController;

@protocol LSPAudioViewControllerDelegate <NSObject>

@optional
- (void)audioViewController:(LSPAudioViewController *)viewController didClosePlayer:(LSPAudioPlayer *)player;
- (void)audioViewController:(LSPAudioViewController *)viewController didPausePlayer:(LSPAudioPlayer *)player;
- (void)audioViewController:(LSPAudioViewController *)viewController didPlayPlayer:(LSPAudioPlayer *)player;
- (void)audioViewController:(LSPAudioViewController *)viewController didStopPlayer:(LSPAudioPlayer *)player;

- (void)audioViewController:(LSPAudioViewController *)viewController willClosePlayer:(LSPAudioPlayer *)player;
- (void)audioViewController:(LSPAudioViewController *)viewController willPausePlayer:(LSPAudioPlayer *)player;
- (void)audioViewController:(LSPAudioViewController *)viewController willPlayPlayer:(LSPAudioPlayer *)player;
- (void)audioViewController:(LSPAudioViewController *)viewController willStopPlayer:(LSPAudioPlayer *)player;

@end


@interface LSPAudioViewController : UIViewController

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, weak) id<LSPAudioViewControllerDelegate> delegate;
@property (nonatomic) CMTime observationInterval;
@property (nonatomic) CMTime seekTolerance;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) LSPAudioView *view;

- (void)assignConstraintsToView:(UIView *)view;
- (void)close;
- (BOOL)isPlaying;
- (void)pause;
- (void)play;
- (void)playAudioWithURL:(NSURL *)url;
- (void)reset;
- (void)stop;

@end
