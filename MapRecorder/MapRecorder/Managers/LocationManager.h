//
//  LocationManager.h
//  MapRecorder
//
//  Created by Ana Neto on 12/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerProtocol <NSObject>
@required
-(BOOL)shouldTrackUserLocation;

@optional
-(void)drawPolylineWith:(NSInteger)numberOfPoints andLocations:(NSMutableArray*)locations;
-(void)presentErrorWhenFailedToRetrieveUserLocation;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic,weak) id<LocationManagerProtocol> delegate;

+ (id)sharedInstance;
-(void)initialize;
-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;

@end
