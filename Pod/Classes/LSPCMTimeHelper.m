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
        formattedTime = [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    }
    else if (totalSeconds > 60)
    {
        formattedTime = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    }
    else
    {
        formattedTime = [NSString stringWithFormat:@"00:%02ld", (long)seconds];
    }
    
    return formattedTime;
}


@end
