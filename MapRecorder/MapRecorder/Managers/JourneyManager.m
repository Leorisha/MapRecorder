//
//  JourneyManager.m
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "JourneyManager.h"

@implementation JourneyManager
@synthesize journeys;

+ (id)sharedInstance {
    static JourneyManager *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.journeys = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)appendJourney:(Journey *)newJourney {
    [self.journeys addObject:newJourney];
}

@end
