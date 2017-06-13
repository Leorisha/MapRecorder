//
//  LocationHelper.m
//  MapRecorder
//
//  Created by Ana Neto on 12/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "LocationHelper.h"
#import "JourneyLogger.h"

@interface LocationHelper ()

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationHelper
@synthesize locationManager;

+ (id)sharedInstance {
    static LocationHelper *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

-(void)startUpdatingLocation {
    locationManager.allowsBackgroundLocationUpdates = YES;
    [self.locationManager startUpdatingLocation];
}

-(void)stopUpdatingLocation {
    locationManager.allowsBackgroundLocationUpdates = NO;
    [self.locationManager stopUpdatingLocation];
}

-(void)initialize {
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    locationManager.pausesLocationUpdatesAutomatically = YES;
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

// MARK: CLLocationDelegate methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.delegate presentErrorWhenFailedToRetrieveUserLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"trying to update location");
    
    if ([self.delegate shouldTrackUserLocation]) {
        
        CLLocation *location = [locations lastObject];
        
        if (location.horizontalAccuracy < 0)
            return;
        
        if (![[JourneyLogger sharedInstance] isTracking]) {
            [[JourneyLogger sharedInstance] beginNewJourneyWith:location];
        }
        else {
            [[JourneyLogger sharedInstance] addToCurrentJourney:location];
        }
        
        NSUInteger count = [[[JourneyLogger sharedInstance] returnCurrentJourneyLocations] count];
        NSLog(@"Tracking location number %lu", count);
        
        if (count > 1) {
            [self.delegate drawPolylineWith:count andLocations:[[JourneyLogger sharedInstance] returnCurrentJourneyLocations]];
        }
        
    }
    
}

@end
