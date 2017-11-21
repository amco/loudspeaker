//
//  LSPCMTimeHelper.m
//
//  Created by Adam Yanalunas on 12/11/13.
//  Copyright (c) 2013 Amco International Education Services, LLC. All rights reserved.
//

#import "LSPCMTimeHelper.h"

@implementation LSPCMTimeHelper

+ (NSString *)readableCMTime:(CMTime)time
{
    NSInteger totalSeconds = CMTimeGetSeconds(time);
    if (totalSeconds < 0) totalSeconds = 0;
    
    NSInteger minutes = floor(totalSeconds % 3600 / 60);
    NSInteger seconds = floor(totalSeconds % 60);
    
    NSString *formattedTime;
    if (totalSeconds > 3600)
    {
        NSInteger hours = floor(totalSeconds / 3600);
        formattedTime = [NSString stringWithFormat:@"%i:%02i:%02i", hours, minutes, seconds];
    }
    else if (totalSeconds > 60)
    {
        formattedTime = [NSString stringWithFormat:@"%02i:%02i", minutes, seconds];
    }
    else
    {
        formattedTime = [NSString stringWithFormat:@"00:%02i", seconds];
    }
    
    return formattedTime;
}


@end
