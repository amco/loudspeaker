//
//  LSPConfiguration.h
//  loudspeaker
//
//  Created by Adam Yanalunas on 11/17/17.
//

#import <CoreMedia/CMTime.h>
#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@class LSPConfiguration;


@interface LSPConfigurationBuilder : NSObject

/**
 Height of the player UI. Currently this is the only configurable layout size.
 Defaults to 60
 */
@property (nonatomic) CGFloat height;

/**
 How often the progress UI updates. Uses `CMTime` which has a format of interval/base.
 Defaults to 1/35th of a second, i.e. `CMTimeMake(1, 35)`.
 */
@property (nonatomic) CMTime observationInterval;

/**
 Defines accuracy of jump position when scrubbing or tapping the playback bar.
 The smaller the tolerance, the more accurate and more costly.
 Defaults to 1/100th of a second, i.e. `CMTimeMake(1, 100)`.
 */
@property (nonatomic) CMTime seekTolerance;

/**
 A 0-1 float for playback volume relative to system volume. Does not control
 volume of the OS.
 Defaults to 1
 */
@property (nonatomic) CGFloat volume;

+ (LSPConfiguration *)configurationWithBuilder:(nullable void (^)(LSPConfigurationBuilder *))builderBlock;
+ (LSPConfiguration *)defaultConfiguration;

- (LSPConfiguration *)build;

@end


@interface LSPConfiguration : NSObject

@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CMTime observationInterval;
@property (nonatomic, readonly) CMTime seekTolerance;
@property (nonatomic, readonly) CGFloat volume;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (nullable instancetype)initWithBuilder:(LSPConfigurationBuilder *)builder NS_DESIGNATED_INITIALIZER;

@end


NS_ASSUME_NONNULL_END
