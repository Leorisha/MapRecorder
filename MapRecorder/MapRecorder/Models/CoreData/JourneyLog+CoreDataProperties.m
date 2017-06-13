//
//  JourneyLog+CoreDataProperties.m
//  MapRecorder
//
//  Created by Ana Neto on 13/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "JourneyLog+CoreDataProperties.h"

@implementation JourneyLog (CoreDataProperties)

+ (NSFetchRequest<JourneyLog *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"JourneyLog"];
}

@dynamic endTime;
@dynamic startTime;
@dynamic title;
@dynamic userLocations;

@end
