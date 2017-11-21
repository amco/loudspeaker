//
//  LSPAudioViewController.h
//
//  Created by Adam Yanalunas on 2/6/14.
//  Copyright (c) 2014 Amco International Education Services, LLC. All rights reserved.
//

#import "LSPAudioView.h"
#import "LSPAudioPlayerModel.h"


NS_ASSUME_NONNULL_BEGIN


@class LSPAudioPlayer, LSPAudioViewController, LSPConfiguration;

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

@property (nonatomic, readonly) LSPConfiguration *configuration;
@property (nonatomic, weak) id<LSPAudioViewControllerDelegate> delegate;
@property (nonatomic) LSPAudioPlayerModel *model;
@property (nonatomic, readonly) LSPAudioView *playerView;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(LSPConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

- (void)close;
- (void)hide:(nullable void (^)(void))completion;
- (BOOL)isPlaying;
- (void)jumpToProgress:(Float64)progress;
- (void)pause;
- (void)play;
- (void)playAudioWithURL:(NSURL *)url;
- (void)reset;
- (void)show;
- (void)stop;

@end


NS_ASSUME_NONNULL_END
