//
//  MapViewController.h
//  MapRecorder
//
//  Created by Ana Neto on 10/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationHelper.h"

/**
 @brief MapViewController is responsible for managing the MapView where the tracking of the user location is displayed. It implements MKMapViewDelegate - which controls the map - and LocationHelperProtocol - which managers the user location update behaviour.
 */
@interface MapViewController : UIViewController <MKMapViewDelegate, LocationHelperProtocol>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trackingButton;


@end

