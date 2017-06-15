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
#import "Log+CoreDataProperties.h"

/**
 JourneyDetailViewController is responsible for displayed the detail of a recorded journey. It has a map and a group of details - start time, end time, distance and average speed which are some metrics than can be recorded using the user location. When a journey is selected from the ListViewController, this screen is opened and Log object is passed to it, and the information on screen is filled using it.
 */
@interface JourneyDetailViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic) Log *journey;
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
