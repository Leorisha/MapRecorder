//
//  Journey.h
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 This is the base model of this application, the core data object is a mirror of this. I've chosen to keep both objects to avoid accessing core data information every time i wish to update the userLocation array during tracking. So Journey objects are used during tracking, for recorded journey, the Log object from Core data is used.
 */
@interface Journey : NSObject

@property (nonatomic) NSMutableArray *userLocations;
@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic) NSString *title;

/**
 A journey is iniatialized with the a first location. That first location is used to set the start time of the journey.

 @param location first location
 @return new Journey object.
 */
-(instancetype)initWithLocation: (CLLocation*)location;

/**
 This method appends a new CLLocation to the userLocation array of the journey.

 @param newLocation a CLLocation object.
 */
-(void)appendNewLocation: (CLLocation *)newLocation;

/**
 When the journey ends, the timestamp of the last location retrieved, it used as the endTime.
 */
-(void)endJourney;


/**
 This should be used to add title to the object.

 @param journeyName new title
 */
-(void)addTitle:(NSString*)journeyName;

@end
