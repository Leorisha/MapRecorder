//
//  JourneyLogger.h
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Journey.h"

@interface JourneyLogger : NSObject

+ (id)sharedInstance;
-(BOOL)isTracking;
-(NSArray*)getJourneyLog;
-(void)beginNewJourneyWith:(CLLocation*)location;
-(void)addToCurrentJourney:(CLLocation*)location;
-(void)endCurrentJourney;
-(NSMutableArray*)returnCurrentJourneyLocations;

@end
