//
//  JourneyManager.h
//  MapRecorder
//
//  Created by Ana Neto on 11/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Journey.h"

@interface JourneyManager : NSObject

@property (nonatomic) NSMutableArray * journeys;

+ (id)sharedInstance;
-(void)appendJourney:(Journey *)newJourney;

@end
