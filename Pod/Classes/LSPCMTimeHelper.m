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
    NSUInteger totalSeconds = CMTimeGetSeconds(time);
    NSUInteger hours = floor(totalSeconds / 3600);
    NSUInteger minutes = floor(totalSeconds % 3600 / 60);
    NSUInteger seconds = floor(totalSeconds % 3600 % 60);
    
    NSString *formattedTime;
    if (hours > 0)
    {
        formattedTime = [NSString stringWithFormat:@"%lu:%02lu:%02lu", (unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];
    }
    else if (minutes > 0)
    {
        formattedTime = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];
    }
    else
    {
        formattedTime = [NSString stringWithFormat:@"0:%02lu", (unsigned long)seconds];
    }
    
    return formattedTime;
}


@end
