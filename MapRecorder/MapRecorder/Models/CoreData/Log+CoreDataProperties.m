//
//  Log+CoreDataProperties.m
//  MapRecorder
//
//  Created by Ana Neto on 13/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "Log+CoreDataProperties.h"

@implementation Log (CoreDataProperties)

+ (NSFetchRequest<Log *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Log"];
}

@dynamic endTime;
@dynamic startTime;
@dynamic title;
@dynamic userLocations;

@end
