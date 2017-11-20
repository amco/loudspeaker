//
//  LSPAudioPlayerModel.m
//  Expecta
//
//  Created by Adam Yanalunas on 11/16/17.
//

#import "LSPAudioPlayerModel.h"


@interface LSPAudioPlayerModel ()

@property (nonatomic) NSURL *url;

@end


@implementation LSPAudioPlayerModel


- (NSString *)title
{
    return self.url.lastPathComponent;
}


- (NSURL *)destination
{
    return self.destination;
}


- (void)setDestination:(NSURL *)url
{
    self.url = url;
}


@end
