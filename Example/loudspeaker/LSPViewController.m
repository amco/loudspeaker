//
//  LSPViewController.m
//  loudspeaker
//
//  Created by Adam Yanalunas on 08/29/2014.
//  Copyright (c) 2014 Adam Yanalunas. All rights reserved.
//

#import "LSPViewController.h"


@interface LSPViewController ()

@property (nonatomic, strong) LSPAudioViewController *audioVC;

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


- (IBAction)launchHarlequinDemo:(id)sender
{
    [self launchDemo:sender];
}


- (void)configureDemo:(id)sender
{
    if (sender == self.harlequinButton)
    {
        self.audioVC.view.progressView.foregroundColor = UIColor.redColor;
        self.audioVC.view.progressView.backgroundColor = UIColor.blueColor;
        self.audioVC.view.backgroundColor = UIColor.greenColor;
        self.audioVC.view.playbackTimeLabel.textColor = UIColor.brownColor;
        self.audioVC.view.titleLabel.textColor = UIColor.yellowColor;
    }
    else
    {
        self.audioVC.view.progressView.foregroundColor = [UIColor colorWithRed:88/255. green:199/255. blue:226/255. alpha:1];
        self.audioVC.view.progressView.backgroundColor = [UIColor colorWithWhite:207/255. alpha:1];
        self.audioVC.view.backgroundColor = [UIColor colorWithWhite:238/255. alpha:1];
        self.audioVC.view.playbackTimeLabel.textColor = [UIColor colorWithWhite:102/255. alpha:1];
        self.audioVC.view.titleLabel.textColor = [UIColor colorWithWhite:102/255. alpha:1];
    }
}


#pragma mark - Player
- (void)playAudioWithURL:(NSURL *)audioURL
{
    [self.audioVC playAudioWithURL:audioURL];
    [self audioViewControllerSetup];
}


- (void)audioViewControllerSetup
{
    LSPAudioViewController *audioVC = self.audioVC;
    
    if (audioVC.parentViewController == self) return;
    
    audioVC.delegate = self;
    [self.view addSubview:audioVC.view];
    
    [audioVC assignConstraintsToView:self.view];
    [self addChildViewController:audioVC];
    
    float bottomOffset = audioVC.bottomConstraint.constant;
    [self.view layoutIfNeeded];
    audioVC.bottomConstraint.constant = CGRectGetHeight(audioVC.view.frame) + ABS(bottomOffset);
    [self.view layoutIfNeeded];
    
    NSTimeInterval duration = .666f;
    NSTimeInterval delay = 0;
    UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:delay options:options animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        audioVC.bottomConstraint.constant = bottomOffset;
        
        [strongSelf.view layoutIfNeeded];
    } completion:nil];
}


- (void)audioViewController:(LSPAudioViewController *)viewController willClosePlayer:(LSPAudioPlayer *)player
{
    __weak typeof(self) weakSelf = self;
    [weakSelf.view layoutIfNeeded];
    
    NSTimeInterval duration = .666f;
    NSTimeInterval delay = 0;
    UIViewAnimationOptions options = (UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut);
    
    [UIView animateWithDuration:duration delay:delay options:options animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        float belowBottom = ABS(viewController.bottomConstraint.constant) + CGRectGetHeight(viewController.view.frame);
        viewController.bottomConstraint.constant = belowBottom;
        
        [strongSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.audioVC reset];
        strongSelf.audioVC = nil;
        
        strongSelf.demoButton.enabled = YES;
        strongSelf.harlequinButton.enabled = YES;
    }];
}


#pragma mark - Properties
- (LSPAudioViewController *)audioVC
{
    if (!_audioVC)
    {
        _audioVC = LSPAudioViewController.new;
    }
    
    return _audioVC;
}


@end
