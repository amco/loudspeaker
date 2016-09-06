//
//  LSPKit.m
//
//  Created by Adam Yanalunas on 8/29/14.
//
//

#import "LSPKit.h"


NSString *const LSPAudioPlayerStart = @"loudspeaker.audio.start";
NSString *const LSPAudioPlayerStop = @"loudspeaker.audio.stop";


@interface LSPKit ()

+ (nullable NSBundle *)loudspeakerBundle;

@end


@implementation LSPKit


+ (NSBundle *)loudspeakerBundle
{
    return [NSBundle bundleWithURL:[[NSBundle bundleForClass:self.class] URLForResource:@"loudspeaker" withExtension:@"bundle"]];
}


+ (UIImage *)imageNamed:(NSString *)name type:(NSString *)type
{
    NSBundle *bundle = self.class.loudspeakerBundle;
    NSString *imageFileName = [NSString stringWithFormat:@"%@.%@", name, type];
    
    return [UIImage imageNamed:imageFileName inBundle:bundle compatibleWithTraitCollection:nil];
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
