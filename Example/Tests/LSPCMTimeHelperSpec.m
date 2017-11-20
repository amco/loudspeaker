//
//  LSPCMTimeHelperSpec.m
//  Tests
//
//  Created by Adam Yanalunas on 11/17/17.
//  Copyright © 2017 Adam Yanalunas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <loudspeaker/loudspeaker.h>


SpecBegin(LSPCMTimeHelperSpec)

describe(@"readableCMTime:", ^{
    it(@"formats a time hours long", ^{
        CMTime time = CMTimeMake(60 * 90, 1);
        NSString *formatted = [LSPCMTimeHelper readableCMTime:time];
        
        expect(formatted).to.equal(@"1:30:00");
    });
    
    it(@"formats a time minutes long", ^{
        CMTime time = CMTimeMake(60 * 45, 1);
        NSString *formatted = [LSPCMTimeHelper readableCMTime:time];
        
        expect(formatted).to.equal(@"45:00");
    });
    
    it(@"formats a time seconds long", ^{
        CMTime time = CMTimeMake(42, 1);
        NSString *formatted = [LSPCMTimeHelper readableCMTime:time];
        
        expect(formatted).to.equal(@"00:42");
    });
    
    it(@"ignores invalid time formats", ^{
        CMTime time = CMTimeMake(-1, 1);
        NSString *formatted = [LSPCMTimeHelper readableCMTime:time];
        
        expect(formatted).to.equal(@"00:00");
    });
});

SpecEnd
