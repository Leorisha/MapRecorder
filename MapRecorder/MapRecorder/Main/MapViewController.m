//
//  MapViewController.m
//  MapRecorder
//
//  Created by Ana Neto on 10/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (nonatomic) CLLocationManager *locationManager;
@property NSMutableArray *userLocations;
@property MKPolyline *userRoute;

@end

@implementation MapViewController
@synthesize mapView;
@synthesize locationManager;
@synthesize trackingButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initializeMap];
    [self initializeLocationManager];
    [self prepareTrackingButton];
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
        }
        
    }
    
}

-(void)prepareTrackingButton {
    
    [trackingButton setTitle:NSLocalizedString(@"tracking_title_off", "")];
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
                                 alertControllerWithTitle:@"Error"
                                 message:@"There was an error retrieving your location"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:nil];
    
    [alert addAction: okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if ([self.trackingButton.title isEqualToString:NSLocalizedString(@"tracking_title_on", "")]) {
        NSLog(@"%@", locations);
        
        CLLocation *location = [locations lastObject];
        
        if (location.horizontalAccuracy < 0)
            return;
        
        if (self.userLocations == nil) {
            self.userLocations = [[NSMutableArray alloc]init];
        }
        
        [self.userLocations addObject:location];
        NSUInteger count = [self.userLocations count];
        
        if (count > 1) {
            CLLocationCoordinate2D coordinates[count];
            for (NSInteger i = 0; i < count; i++) {
                coordinates[i] = [(CLLocation *)self.userLocations[i] coordinate];
            }
            
            MKPolyline *oldUserRoute = self.userRoute;
            self.userRoute = [MKPolyline polylineWithCoordinates:coordinates count:count];
            [self.mapView addOverlay:self.userRoute];
            if (oldUserRoute)
                [self.mapView removeOverlay:oldUserRoute];
        }
        
    }
    
}

@end
