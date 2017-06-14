//
//  JourneyDetailViewController.h
//  MapRecorder
//
//  Created by Ana Neto on 12/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JourneyLogger.h"
#import "Journey.h"
#import "JourneyLog+CoreDataProperties.h"

@interface JourneyDetailViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic) JourneyLog *journey;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *speedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;


@end
