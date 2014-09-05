//
//  LSPViewController.h
//  loudspeaker
//
//  Created by Adam Yanalunas on 08/29/2014.
//  Copyright (c) 2014 Adam Yanalunas. All rights reserved.
//

#import <LSPAudioViewController.h>
#import <UIKit/UIKit.h>

@interface LSPViewController : UIViewController <LSPAudioViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *demoButton;
@property (weak, nonatomic) IBOutlet UIButton *harlequinButton;

- (IBAction)launchDemo:(id)sender;
- (IBAction)launchHarlequinDemo:(id)sender;

@end
