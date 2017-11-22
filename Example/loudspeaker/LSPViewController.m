//
//  LSPViewController.m
//  loudspeaker
//
//  Created by Adam Yanalunas on 08/29/2014.
//  Copyright (c) 2014 Adam Yanalunas. All rights reserved.
//

#import "LSPViewController.h"
#import <loudspeaker/loudspeaker.h>


@interface LSPViewController ()

@property (nonatomic) LSPAudioViewController *audioVC;
@property (nonatomic) LSPConfiguration *configuration;

- (void)audioViewControllerSetup;
- (void)configureDemo:(id)sender;
- (void)playAudioWithURL:(NSURL *)audioURL;

@end


@implementation LSPViewController


#pragma mark - Demo
- (IBAction)launchDemo:(id)sender
{
    self.demoButton.enabled = NO;
    self.harlequinButton.enabled = NO;
    
    [self configureDemo:sender];
    
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:@"Nyan-Cat" withExtension:@"mp3"];
    [self playAudioWithURL:audioURL];
}


- (void)resetDemoButtons
{
    self.demoButton.enabled = YES;
    self.harlequinButton.enabled = YES;
}


- (IBAction)launchHarlequinDemo:(id)sender
{
    [self launchDemo:sender];
}


- (void)configureDemo:(id)sender
{
    if (sender == self.harlequinButton)
    {
        self.configuration = [LSPConfigurationBuilder configurationWithBuilder:^(LSPConfigurationBuilder *builder) {
            builder.volume = 0.1;
        }];
        self.audioVC = [LSPAudioViewController.alloc initWithConfiguration:self.configuration];
        CGFloat playerHeight = 120;
        self.audioVC.view.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - playerHeight, CGRectGetWidth(self.view.frame), playerHeight);
        
        self.audioVC.playerView.progressView.foregroundColor = UIColor.redColor;
        self.audioVC.playerView.progressView.backgroundColor = UIColor.blueColor;
        self.audioVC.playerView.backgroundColor = UIColor.greenColor;
        self.audioVC.playerView.playbackTimeLabel.textColor = UIColor.brownColor;
        self.audioVC.playerView.titleLabel.textColor = UIColor.yellowColor;
    }
    else
    {
        self.configuration = [LSPConfigurationBuilder.defaultConfiguration build];
        self.audioVC = [LSPAudioViewController.alloc initWithConfiguration:self.configuration];
        CGFloat playerHeight = 60;
        self.audioVC.view.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - playerHeight, CGRectGetWidth(self.view.frame), playerHeight);

        self.audioVC.playerView.progressView.foregroundColor = [UIColor colorWithRed:88/255. green:199/255. blue:226/255. alpha:1];
        self.audioVC.playerView.progressView.backgroundColor = [UIColor colorWithWhite:207/255. alpha:1];
        self.audioVC.playerView.backgroundColor = [UIColor colorWithWhite:238/255. alpha:1];
        self.audioVC.playerView.playbackTimeLabel.textColor = [UIColor colorWithWhite:102/255. alpha:1];
        self.audioVC.playerView.titleLabel.textColor = [UIColor colorWithWhite:102/255. alpha:1];
    }
}


#pragma mark - Player
- (void)playAudioWithURL:(NSURL *)audioURL
{
    [self audioViewControllerSetup];
    [self.audioVC playAudioWithURL:audioURL];
    [self.audioVC show];
}


- (void)audioViewControllerSetup
{
    self.audioVC.delegate = self;
    [self.view addSubview:self.audioVC.view];
    
    [self.audioVC willMoveToParentViewController:self];
    [self addChildViewController:self.audioVC];
    [self.audioVC didMoveToParentViewController:self];
}


- (void)audioViewController:(LSPAudioViewController *)viewController didClosePlayer:(LSPAudioPlayer *)player
{
    [self resetDemoButtons];
}


@end
