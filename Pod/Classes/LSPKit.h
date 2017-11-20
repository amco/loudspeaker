//
//  LSPKit.h
//
//  Created by Adam Yanalunas on 8/29/14.
//
//

#import <Foundation/Foundation.h>


#define DELEGATE_SAFELY(obj, selector, ...) \
if ([obj respondsToSelector:selector]) { __VA_ARGS__ }


NS_ASSUME_NONNULL_BEGIN


extern NSString *const LSPAudioPlayerStart;
extern NSString *const LSPAudioPlayerStop;


@interface LSPKit : NSObject

+ (UIImage *)closeIcon;
+ (NSString *)fontName;
+ (nullable UIImage *)imageNamed:(NSString *)name type:(NSString *)type;
+ (nullable NSString *)localizedString:(NSString *)string;
+ (UIImage *)pauseIcon;
+ (UIImage *)playIcon;

@end


NS_ASSUME_NONNULL_END
