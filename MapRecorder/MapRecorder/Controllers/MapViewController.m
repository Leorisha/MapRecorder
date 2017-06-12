//
//  MapViewController.m
//  MapRecorder
//
//  Created by Ana Neto on 10/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "MapViewController.h"
#import "JourneyManager.h"

@interface MapViewController ()
@property LocationManager *locationManager;
@property JourneyManager *journeyManager;
@property MKPolyline *userCurrentRoute;

@end

@implementation MapViewController
@synthesize mapView;
@synthesize trackingButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self prepareController];
    [self initializeMap];
    [self prepareTracking];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)trackingButtonPressed:(id)sender {
    
    if ((UIBarButtonItem *)sender == self.trackingButton) {
        
        if (![self.journeyManager isTracking]) {
            [trackingButton setTitle:NSLocalizedString(@"tracking_title_on", "")];
            [self.locationManager startUpdatingLocation];  //requesting location updates
        }
        else {
            [trackingButton setTitle:NSLocalizedString(@"tracking_title_off", "")];
            [self.locationManager stopUpdatingLocation];
            [self.journeyManager endCurrentJourney];
        }
        
    }
    
}

-(void)prepareController {
    [self.navigationController.tabBarController.tabBar.items objectAtIndex:0].title = NSLocalizedString(@"map_title", "");
    [self.navigationController.tabBarController.tabBar.items objectAtIndex:1].title = NSLocalizedString(@"list_title", "");
    self.navigationItem.title = NSLocalizedString(@"map_title", "");
}

-(void)prepareTracking {
    [trackingButton setTitle:NSLocalizedString(@"tracking_title_off", "")];
    self.journeyManager = [JourneyManager sharedInstance];
    self.locationManager = [LocationManager sharedInstance];
    [self.locationManager initialize];
    self.locationManager.delegate = self;
}

-(void)initializeMap {
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeHybrid;
    mapView.delegate = self;
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

// MARK: - LocationManagerProtocol methods

-(BOOL)shouldTrackUserLocation {
    return [self.trackingButton.title isEqualToString:NSLocalizedString(@"tracking_title_on", "")];
}

-(void)presentErrorWhenFailedToRetrieveUserLocation {
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

-(void)drawPolylineWith:(NSInteger)numberOfPoints andLocations:(NSMutableArray*)locations {
    CLLocationCoordinate2D coordinates[numberOfPoints];
    for (NSInteger i = 0; i < numberOfPoints; i++) {
        coordinates[i] = [(CLLocation *)locations[i] coordinate];
    }
    
    MKPolyline *oldUserRoute = self.userCurrentRoute;
    self.userCurrentRoute = [MKPolyline polylineWithCoordinates:coordinates count:numberOfPoints];
    [self.mapView addOverlay:self.userCurrentRoute];
    if (oldUserRoute)
        [self.mapView removeOverlay:oldUserRoute];
}

@end
