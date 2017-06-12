//
//  MapViewController.m
//  MapRecorder
//
//  Created by Ana Neto on 10/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "MapViewController.h"
#import "Journey.h"
#import "JourneyManager.h"

@interface MapViewController ()

@property (nonatomic) CLLocationManager *locationManager;
@property JourneyManager *journeyManager;
@property Journey *userJourney;
@property MKPolyline *userCurrentRoute;

@end

@implementation MapViewController
@synthesize mapView;
@synthesize locationManager;
@synthesize trackingButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self prepareController];
    [self initializeMap];
    [self initializeLocationManager];
    [self prepareTracking];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)trackingButtonPressed:(id)sender {
    
    if ((UIBarButtonItem *)sender == self.trackingButton) {
        
        if ([trackingButton.title isEqualToString:NSLocalizedString(@"tracking_title_off", "")]) {
            [trackingButton setTitle:NSLocalizedString(@"tracking_title_on", "")];
        }
        else {
            [trackingButton setTitle:NSLocalizedString(@"tracking_title_off", "")];
            [self endCurrentJourney];
        }
        
    }
    
}

-(void)endCurrentJourney {
    [self.userJourney endJourney];
    [self.userJourney addTitle: [NSString stringWithFormat:@"%@ %lu", NSLocalizedString(@"default_journey_title", ""), self.journeyManager.journeys.count+1]];
    [self.journeyManager appendJourney:self.userJourney];
    self.userJourney = nil;
}

-(void)prepareController {
    [self.navigationController.tabBarController.tabBar.items objectAtIndex:0].title = NSLocalizedString(@"map_title", "");
    [self.navigationController.tabBarController.tabBar.items objectAtIndex:1].title = NSLocalizedString(@"list_title", "");
    self.navigationItem.title = NSLocalizedString(@"map_title", "");
}

-(void)prepareTracking {
    [trackingButton setTitle:NSLocalizedString(@"tracking_title_off", "")];
    self.journeyManager = [JourneyManager sharedInstance];
}

-(void)initializeMap {
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeHybrid;
    mapView.delegate = self;
}

-(void)initializeLocationManager {
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];  //requesting location updates
}

// MARK: - MKMapViewDelegate methods

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
    
}

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

// MARK: - CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"user_location_error_title", "")
                                 message:NSLocalizedString(@"user_location_error_message", "")
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"ok", "")
                                style:UIAlertActionStyleDefault
                                handler:nil];
    
    [alert addAction: okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if ([self.trackingButton.title isEqualToString:NSLocalizedString(@"tracking_title_on", "")]) {
        CLLocation *location = [locations lastObject];
        
        if (location.horizontalAccuracy < 0)
            return;
        
        if (self.userJourney == nil) {
            self.userJourney = [[Journey alloc] initWithLocation:location];
        }
        else {
            [self.userJourney appendNewLocation:location];
        }
        
        NSUInteger count = [self.userJourney.userLocations count];
        
        if (count > 1) {
            CLLocationCoordinate2D coordinates[count];
            for (NSInteger i = 0; i < count; i++) {
                coordinates[i] = [(CLLocation *)self.userJourney.userLocations[i] coordinate];
            }
            
            MKPolyline *oldUserRoute = self.userCurrentRoute;
            self.userCurrentRoute = [MKPolyline polylineWithCoordinates:coordinates count:count];
            [self.mapView addOverlay:self.userCurrentRoute];
            if (oldUserRoute)
                [self.mapView removeOverlay:oldUserRoute];
        }
        
    }
    
}

@end
