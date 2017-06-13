//
//  JourneyLog+CoreDataProperties.h
//  MapRecorder
//
//  Created by Ana Neto on 13/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "JourneyLog+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface JourneyLog (CoreDataProperties)

+ (NSFetchRequest<JourneyLog *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *endTime;
@property (nullable, nonatomic, copy) NSDate *startTime;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) NSData *userLocations;

@end

NS_ASSUME_NONNULL_END
