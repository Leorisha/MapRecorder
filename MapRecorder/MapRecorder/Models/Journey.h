//
//  Journey.h
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Journey : NSObject

@property (nonatomic) NSMutableArray *userLocations;
@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic) NSString *title;

-(instancetype)initWithLocation: (CLLocation*)location;
-(void)appendNewLocation: (CLLocation *)newLocation;
-(void)endJourney;

@end
