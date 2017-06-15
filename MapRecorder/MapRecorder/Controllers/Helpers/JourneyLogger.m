//
//  Logger.m
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "JourneyLogger.h"
#import "AppDelegate.h"
#import "Log+CoreDataClass.h"

@interface JourneyLogger ()

/**
 @brief this is a private instance of the Journey class, to store the data which the app is recording. This variable should only be different of nil when there is an on going tracking event.
 */
@property (nonatomic) Journey *currentJourney;

@end


@implementation JourneyLogger
@synthesize currentJourney;

+ (id)sharedInstance {
    static JourneyLogger *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

-(BOOL)isTracking {
    return currentJourney != nil;
}

-(NSArray*)getLog {
    AppDelegate *appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSFetchRequest<Log *> *fetchRequest = [Log fetchRequest];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error ;
    
    return [context executeFetchRequest:fetchRequest error:&error];
}

-(NSArray*)returnCurrentJourneyLocations {
    return self.currentJourney.userLocations;
}

-(void)beginNewJourneyWith:(CLLocation*)location {
    self.currentJourney = [[Journey alloc] initWithLocation:location];
}

-(void)addToCurrentJourney:(CLLocation*)location {
    [self.currentJourney.userLocations addObject:location];
}

-(void)endCurrentJourney {
    [self.currentJourney endJourney];
    
    [self.currentJourney addTitle: [NSString stringWithFormat:@"%@ %lu", NSLocalizedString(@"default_journey_title", ""), [self getLog].count+1]];
    [self save:self.currentJourney];
    self.currentJourney = nil;
}

/**
 Saves the current journey persistently.

 @param journey the current journey.
 */
-(void)save:(Journey*)journey {
    
    AppDelegate *appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSManagedObject *newJourney = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
    
    [newJourney setValue:journey.title forKey:@"title"];
    [newJourney setValue:journey.startTime forKey:@"startTime"];
    [newJourney setValue:journey.endTime forKey:@"endTime"];
    
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:journey.userLocations];
    [newJourney setValue:arrayData forKey:@"userLocations"];
    
    [appDelegate saveContext];
}

@end
