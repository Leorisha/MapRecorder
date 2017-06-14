//
//  JourneyLogger.m
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "JourneyLogger.h"
#import "AppDelegate.h"
#import "JourneyLog+CoreDataClass.h"

@interface JourneyLogger ()

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

-(NSArray*)getJourneyLog {
    AppDelegate *appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSFetchRequest<JourneyLog *> *fetchRequest = [JourneyLog fetchRequest];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error ;
    
    return [context executeFetchRequest:fetchRequest error:&error];
}

-(NSMutableArray*)returnCurrentJourneyLocations {
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
    
    [self.currentJourney addTitle: [NSString stringWithFormat:@"%@ %lu", NSLocalizedString(@"default_journey_title", ""), [self getJourneyLog].count+1]];
    [self save:self.currentJourney];
    self.currentJourney = nil;
}

-(void)save:(Journey*)journey {
    
    AppDelegate *appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSManagedObject *newJourney = [NSEntityDescription insertNewObjectForEntityForName:@"JourneyLog" inManagedObjectContext:context];
    
    [newJourney setValue:journey.title forKey:@"title"];
    [newJourney setValue:journey.startTime forKey:@"startTime"];
    [newJourney setValue:journey.endTime forKey:@"endTime"];
    
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:journey.userLocations];
    [newJourney setValue:arrayData forKey:@"userLocations"];
    
    [appDelegate saveContext];
}

@end
