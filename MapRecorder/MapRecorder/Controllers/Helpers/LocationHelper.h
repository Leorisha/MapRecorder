//
//  LocationHelper.h
//  MapRecorder
//
//  Created by Ana Neto on 12/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 @brief This protocol allow a delegation on what should be done when a certain there is an update on the user location. The only required method is the shouldTrackUserLocation since the use of CLLocationManager could not be managed without it. Addionality this protocols also allows to control what happens when there is an error or when a location is sucessfully retrieved.
 */
@protocol LocationHelperProtocol <NSObject>
@required
-(BOOL)shouldTrackUserLocation;

@optional
-(void)drawPolylineWith:(NSInteger)numberOfPoints andLocations:(NSMutableArray*)locations;
-(void)presentErrorWhenFailedToRetrieveUserLocation;

@end

/**
 @brief LocationHelper is wrapper around the apple's CLLocationManager. I've chosen to make this a singleton to be easier to acess locationManager through multiple screens and appdelegate, and to be sure that when I intend to stop the location from being updated there is no leaking instances working on background.
 */
@interface LocationHelper : NSObject <CLLocationManagerDelegate>

@property (nonatomic,weak) id<LocationHelperProtocol> delegate;

/**
 @brief This method returns a shared instantition of a LocationHelper, this should be used instead of init method (which is private anyway) to ensure that this class remains a singleton.
 
 @return return a new or a previously created instance of LocationHelper.
 */
+ (id)sharedInstance;

/**
 This should be called before doing anything else. This method is responsible for preparing this class to be used.
 */
-(void)initialize;

/**
 This method initializes the user location tracking.
 */
-(void)startUpdatingLocation;


/**
 This method stops the user location tracking.
 */
-(void)stopUpdatingLocation;

@end
