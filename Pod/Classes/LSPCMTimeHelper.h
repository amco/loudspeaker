//
//  LSPCMTimeHelper.h
//
//  Created by Adam Yanalunas on 12/11/13.
//  Copyright (c) 2013 Amco International Education Services, LLC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface LSPCMTimeHelper : NSObject

+ (NSString *)readableCMTime:(CMTime)time;

@end
