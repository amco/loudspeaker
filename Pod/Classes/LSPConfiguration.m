//
//  LSPConfiguration.m
//  loudspeaker
//
//  Created by Adam Yanalunas on 11/17/17.
//

#import "LSPConfiguration.h"


@implementation LSPConfigurationBuilder

+ (LSPConfigurationBuilder *)defaultConfiguration
{
    LSPConfigurationBuilder *config = LSPConfigurationBuilder.new;
    config.seekTolerance = CMTimeMake(1, 100);
    config.observationInterval = CMTimeMake(1, 35);
    config.volume = 1;
    
    return config;
}


+ (LSPConfiguration *)configurationWithBuilder:(nullable void (^)(LSPConfigurationBuilder *))builderBlock
{
    LSPConfigurationBuilder *builder = LSPConfigurationBuilder.defaultConfiguration;
    builderBlock(builder);
    
    return [builder build];
}


- (LSPConfiguration *)build
{
    return [LSPConfiguration.alloc initWithBuilder:self];
}

@end


@implementation LSPConfiguration

- (instancetype)initWithBuilder:(LSPConfigurationBuilder *)builder
{
    self = [super init];
    if (!self) return nil;
    
    _seekTolerance = builder.seekTolerance;
    _observationInterval = builder.observationInterval;
    _volume = builder.volume;
    
    return self;
}

@end
