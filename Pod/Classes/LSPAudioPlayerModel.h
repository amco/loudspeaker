//
//  LSPAudioPlayerModel.h
//  Expecta
//
//  Created by Adam Yanalunas on 11/16/17.
//


#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@interface LSPAudioPlayerModel : NSObject

- (nullable NSURL *)destination;
- (void)setDestination:(NSURL *)url;
- (nullable NSString *)title;

@end


NS_ASSUME_NONNULL_END
