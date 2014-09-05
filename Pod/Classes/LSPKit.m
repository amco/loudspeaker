//
//  LSPKit.m
//
//  Created by Adam Yanalunas on 8/29/14.
//
//

#import "LSPKit.h"


NSString *const LSPAudioPlayerStart = @"loudspeaker.audio.start";
NSString *const LSPAudioPlayerStop = @"loudspeaker.audio.stop";


@implementation LSPKit


+ (UIImage *)imageNamed:(NSString *)name type:(NSString *)type
{
    CGFloat scale = [UIScreen mainScreen].scale;
    static NSString *bundleName = @"loudspeaker.bundle";
    NSString *resourceName = [NSString stringWithFormat:@"%@/%@", bundleName, name];
    
    if (scale > 1)
    {
        NSString *scaleAmount = [NSString stringWithFormat:@"@%ix", (int)scale];
        resourceName = [resourceName stringByAppendingString:scaleAmount];
    }
    
    NSString *extension = type ?: @"png";
    NSURL *url = [[NSBundle mainBundle] URLForResource:resourceName withExtension:extension];
    
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image;
    if (imageData)
    {
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef) imageData);
        CGImageRef imageRef = CGImageCreateWithPNGDataProvider(provider, NULL, YES, kCGRenderingIntentDefault);
        
        image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        
        CFRelease(imageRef);
        CFRelease(provider);
    }
    
    return image;
}

+ (UIImage *)closeIcon
{
    return [self.class imageNamed:@"audio_close_icon" type:@"png"];
}


+ (NSString *)fontName
{
    return @"Helvetica-Neue";
}


+ (UIImage *)pauseIcon
{
    return [self.class imageNamed:@"audio_pause_icon" type:@"png"];
}


+ (UIImage *)playIcon
{
    return [self.class imageNamed:@"audio_play_icon" type:@"png"];
}

@end
