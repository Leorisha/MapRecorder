//
//  JourneyManager.m
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "JourneyManager.h"

@interface JourneyManager ()

@property (nonatomic) Journey *currentJourney;

@end


@implementation JourneyManager
@synthesize journeys;
@synthesize currentJourney;

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

-(BOOL)isTracking {
    return currentJourney != nil;
}

-(NSMutableArray*)returnCurrentJourneyLocations {
    return self.currentJourney.userLocations;
}

-(void)beginNewJourneyWith:(CLLocation*)location {
    self.currentJourney = [[Journey alloc] initWithLocation:location];
}

-(void)addToCurrentJourney:(CLLocation*)location {
    [self.currentJourney.userLocations addObject:location];
}

-(void)endCurrentJourney {
    [self.currentJourney endJourney];
    [self.currentJourney addTitle: [NSString stringWithFormat:@"%@ %lu", NSLocalizedString(@"default_journey_title", ""), self.journeys.count+1]];
    [self.journeys addObject:self.currentJourney];
    self.currentJourney = nil;
}

@end
