//
//  LSPKit.h
//
//  Created by Adam Yanalunas on 8/29/14.
//
//

#import <Foundation/Foundation.h>


#define DELEGATE_SAFELY(obj, selector, ...) \
if ([obj respondsToSelector:selector]) { __VA_ARGS__ }


extern NSString *const LSPAudioPlayerStart;
extern NSString *const LSPAudioPlayerStop;


@interface LSPKit : NSObject

+ (UIImage *)closeIcon;
+ (NSString *)fontName;
+ (UIImage *)imageNamed:(NSString *)name type:(NSString *)type;
+ (UIImage *)pauseIcon;
+ (UIImage *)playIcon;

@end
