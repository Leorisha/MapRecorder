//
//  MapViewController.h
//  MapRecorder
//
//  Created by Ana Neto on 10/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationManager.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, LocationManagerProtocol>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackingButton;


@end

