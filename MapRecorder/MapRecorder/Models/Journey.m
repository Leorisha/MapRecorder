//
//  Journey.m
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "Journey.h"

@implementation Journey
@synthesize title;
@synthesize userLocations;
@synthesize endTime;
@synthesize startTime;

-(instancetype)initWithLocation: (CLLocation*)location {
    self = [super init];
    
    if(self) {
        userLocations = [[NSMutableArray alloc] initWithObjects:location,nil];
        startTime = location.timestamp;
    }
    
    return self;
}

-(void)appendNewLocation: (CLLocation *)newLocation {
    [userLocations addObject:newLocation];
}

-(void)addTitle:(NSString*)journeyName {
    title = journeyName;
}

-(void)endJourney {
    endTime = ((CLLocation*)[userLocations lastObject]).timestamp;
}

@end
