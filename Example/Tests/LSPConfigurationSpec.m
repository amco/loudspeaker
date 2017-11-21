//
//  LSPConfigurationSpec.m
//  Tests
//
//  Created by Adam Yanalunas on 11/20/17.
//  Copyright © 2017 Adam Yanalunas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <loudspeaker/loudspeaker.h>


SpecBegin(LSPConfigurationBuild)


describe(@"defaultConfiguration", ^{
    __block LSPConfiguration *config;
    
    beforeEach(^{
        config = LSPConfigurationBuilder.defaultConfiguration;
    });
    
    it(@"contains the default configuration values", ^{
        expect(config.seekTolerance.value).to.equal(1);
        expect(config.seekTolerance.timescale).to.equal(100);
        expect(config.observationInterval.value).to.equal(1);
        expect(config.observationInterval.timescale).to.equal(35);
        expect(config.volume).to.equal(1);
    });
});

describe(@"configurationWithBuilder:", ^{
    __block LSPConfiguration *config;
    
    beforeEach(^{
        config = [LSPConfigurationBuilder configurationWithBuilder:^(LSPConfigurationBuilder *builder) {
            builder.seekTolerance = CMTimeMake(1, 2);
            builder.observationInterval = CMTimeMake(3, 4);
            builder.volume = .2;
        }];
    });
    
    it(@"uses the given values to build a configuration", ^{
        expect(config.seekTolerance.value).to.equal(1);
        expect(config.seekTolerance.timescale).to.equal(2);
        expect(config.observationInterval.value).to.equal(3);
        expect(config.observationInterval.timescale).to.equal(4);
        expect(config.volume).to.equal(.2);
    });
});


SpecEnd
