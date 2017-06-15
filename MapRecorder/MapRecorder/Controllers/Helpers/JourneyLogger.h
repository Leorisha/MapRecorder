//
//  Logger.h
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Journey.h"

/**
 This class is the responsible for doing all the work related with the journey recording. I've chosen to make it a singleton to avoid having multiple instances tracking and accessing the data.
 */
@interface JourneyLogger : NSObject

/**
 @brief This method returns a shared instantition of a JourneyLogger, this should be used instead of init method (which is private anyway) to ensure that this class remains a singleton.
 
 @return return a new or a previously created instance of JourneyLogger.
 */
+ (id)sharedInstance;

/**
 @brief There is a tracking ongoing event if the currentJourney is not empty.
 
 @return TRUE if there is an on going tracking event, FALSE otherwise.
 */
-(BOOL)isTracking;

/**
 @brief This method fetches the data from core data and returns it.
 
 @return NSArray of Log class (used in core data).
 */
-(NSArray*)getLog;

/**
 @brief This method instantiate the currentJourney element.
 
 @param location the first CLLocation tracked in the new journey.
 */
-(void)beginNewJourneyWith:(CLLocation*)location;

/**
 @brief This method adds a new tracked CLLocation to the currentJourney object.
 
 @param location the new CLLocation.
 */
-(void)addToCurrentJourney:(CLLocation*)location;

/**
 @brief When To stop the tracking, this method should be called - a title and an ending timestamp is given to the now closed journey and the journey is saved in the core data of the app.
 */
-(void)endCurrentJourney;

/**
 @brief This methods returns the current stored user position associated with the on going journey being tracked.
 
 @return NSArray of CLLocation.
 */
-(NSArray*)returnCurrentJourneyLocations;

@end
