//
//  Journey.m
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "Journey.h"

@implementation Journey

-(instancetype)initWithLocation: (CLLocation*)location {
    self = [super init];
    
    if(self) {
        _userLocations = [[NSMutableArray alloc] initWithObjects:location,nil];
        _startTime = location.timestamp;
    }
    
    return self;
}

-(void)appendNewLocation: (CLLocation *)newLocation {
    [_userLocations addObject:newLocation];
}

-(void)endJourney {
    _endTime = ((CLLocation*)[_userLocations lastObject]).timestamp;
}

@end
