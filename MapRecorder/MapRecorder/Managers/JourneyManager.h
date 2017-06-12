//
//  JourneyManager.h
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Journey.h"

@interface JourneyManager : NSObject

@property (nonatomic) NSMutableArray * journeys;

+ (id)sharedInstance;
-(BOOL)isTracking;
-(void)beginNewJourneyWith:(CLLocation*)location;
-(void)addToCurrentJourney:(CLLocation*)location;
-(void)endCurrentJourney;
-(NSMutableArray*)returnCurrentJourneyLocations;

@end
