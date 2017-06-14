//
//  JourneyDetailViewController.m
//  MapRecorder
//
//  Created by Ana Neto on 12/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "JourneyDetailViewController.h"

@interface JourneyDetailViewController ()

@end

@implementation JourneyDetailViewController
@synthesize startTimeLabel,endTimeLabel,startTitleLabel, endTitleLabel, distanceLabel, distanceTitleLabel, speedLabel, speedTitleLabel, journey, mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareMap];
    [self prepareValuesOnScreen];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareMap {
    mapView.mapType = MKMapTypeHybrid;
    mapView.delegate = self;
}

-(void)prepareValuesOnScreen {
    
    // titles
    self.startTitleLabel.text = NSLocalizedString(@"start_time_title", "");
    self.endTitleLabel.text = NSLocalizedString(@"end_time_title", "");
    self.distanceTitleLabel.text = NSLocalizedString(@"distance_title", "");
    self.speedTitleLabel.text = NSLocalizedString(@"speed_title", "");
    
    // values
    if (self.journey != nil && self.journey.startTime != nil && self.journey.endTime != nil && self.journey.title != nil) {
        self.navigationItem.title = self.journey.title;
        self.startTimeLabel.text = [self convert:self.journey.startTime];
        self.endTimeLabel.text = [self convert:self.journey.endTime];
        
        NSArray *userLocations = [NSKeyedUnarchiver unarchiveObjectWithData:self.journey.userLocations];
        
        if (self.journey.userLocations != nil ) {
            [self drawPolylineWith:userLocations];
        }
        
        self.distanceLabel.text = [self calculateDistanceWith:userLocations];
        self.speedLabel.text = [self calculateSpeedWith:userLocations];
    }
}

-(NSString*)calculateSpeedWith:(NSArray*)userLocations {

    CLLocationSpeed totalSpeed = 0;
    
    for (CLLocation *location in userLocations) {
        totalSpeed += (location.speed * 3.6);
    }
    
    return [NSString stringWithFormat:@"%f Km/s.", (totalSpeed/userLocations.count)];
    
}


-(NSString*)calculateDistanceWith:(NSArray*)userLocations {
    
    CLLocationDistance totalKilometers = 0;
    
    for (int i = 0; i < (userLocations.count - 1); i++) // <-- count - 1
    {
        CLLocationDistance distance = [[userLocations objectAtIndex:i] distanceFromLocation:[userLocations objectAtIndex:(i + 1)]];
        CLLocationDistance kilometers = distance / 1000.0;
        totalKilometers += kilometers;
    }
    
    return [NSString stringWithFormat:@"%f Km.", totalKilometers];
}

-(void)drawPolylineWith:(NSArray*)locations {
    
    NSInteger count = locations.count;
    
    CLLocationCoordinate2D coordinates[count];
    for (NSInteger i = 0; i < count; i++) {
        coordinates[i] = [(CLLocation *)locations[i] coordinate];
    }
    
    MKPolyline *route = [MKPolyline polylineWithCoordinates:coordinates count:count];
    [self.mapView addOverlay:route];
    
    [self.mapView setVisibleMapRect:[route boundingMapRect] edgePadding:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0) animated:true];
}

-(NSString*)convert:(NSDate*)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    return [df stringFromDate:date];
}

// MARK: MapDelegate methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 3;
        
        return renderer;
    }
    
    return nil;
}

@end
