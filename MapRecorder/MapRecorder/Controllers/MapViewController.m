//
//  MapViewController.m
//  MapRecorder
//
//  Created by Ana Neto on 10/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "MapViewController.h"
#import "JourneyLogger.h"

@interface MapViewController ()

@property LocationHelper *locationManager;
@property JourneyLogger *journeyLogger;

@property MKPolyline *userCurrentRoute;

@end

@implementation MapViewController
@synthesize mapView,trackingButton;

#pragma mark - ViewController lifecycle methods

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

#pragma mark - IBAction methods

- (IBAction)trackingButtonPressed:(id)sender {
    
    if ((UIBarButtonItem *)sender == self.trackingButton) {
        
        if (![self.journeyLogger isTracking]) {
            // if the tracking is not active
            [trackingButton setTitle:NSLocalizedString(@"tracking_title_on", "")];
            [self.locationManager startUpdatingLocation]; // requesting location updates
        }
        else {
            // if tracking is active
            [trackingButton setTitle:NSLocalizedString(@"tracking_title_off", "")];
            [self.locationManager stopUpdatingLocation]; // stop location updates
            [self.journeyLogger endCurrentJourney]; // close journey
        }
        
    }
    
}

#pragma mark - Auxiliar methods

/**
 @brief this method does the UI preparation for this View controller, setting the localization strings on the necessary UI elements.
 */
-(void)prepareController {
    [self.navigationController.tabBarController.tabBar.items objectAtIndex:0].title = NSLocalizedString(@"map_title", "");
    [self.navigationController.tabBarController.tabBar.items objectAtIndex:1].title = NSLocalizedString(@"list_title", "");
    self.navigationItem.title = NSLocalizedString(@"map_title", "");
    [trackingButton setTitle:NSLocalizedString(@"tracking_title_off", "")];
}

/**
 @brief this method does all the necessary preparation associated with the tracking action, initializing the Log and the location manager to be ready to use.
 */
-(void)prepareTracking {
    self.journeyLogger = [JourneyLogger sharedInstance];
    self.locationManager = [LocationHelper sharedInstance];
    [self.locationManager initialize];
    self.locationManager.delegate = self;
}

/**
 @brief this method does all the necessary configuration for the map to be used.
 */
-(void)initializeMap {
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeHybrid;
    mapView.delegate = self;
}


#pragma mark - MKMapViewDelegate methods

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    
    // keps the user position to be always on the center of the map
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
        // If there is some polyline added as overlay to the map
        // Renders the polyline with blue color and lineWidth of 3
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 3;
        
        return renderer;
    }
    
    return nil;
}

#pragma mark - LocationHelperProtocol methods

/**
 This method should return a value which will be used by the Location Helper that contains the CLocationManager instance, to define if the tracking should be enabled or disabled.

 @return TRUE if tracking should be enable, FALSE otherwise.
 */
-(BOOL)shouldTrackUserLocation {
    // here its defined that the app should be tracking if the trackingButton on the navigation bar is using a specific text.
    return [self.trackingButton.title isEqualToString:NSLocalizedString(@"tracking_title_on", "")];
}

-(void)presentErrorWhenFailedToRetrieveUserLocation {
    
    // An alert is displayed if by any chance the app receives an error when trying to update the user location.
    
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
    
    //Extracts the coordinate component of the gathered user locations of the current journey.
    CLLocationCoordinate2D coordinates[numberOfPoints];
    for (NSInteger i = 0; i < numberOfPoints; i++) {
        coordinates[i] = [(CLLocation *)locations[i] coordinate];
    }
    
    // saves the current route
    MKPolyline *oldUserRoute = self.userCurrentRoute;
    // creates a new polyline to represent the current route on the map using the extracted coordinates.
    self.userCurrentRoute = [MKPolyline polylineWithCoordinates:coordinates count:numberOfPoints];
    //add it to the map
    [self.mapView addOverlay:self.userCurrentRoute];
    if (oldUserRoute)
        //removes the old route to avoid multiple route overlapping.
        [self.mapView removeOverlay:oldUserRoute];
}

@end
