//
//  JourneyDetailViewController.h
//  MapRecorder
//
//  Created by Ana Neto on 12/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JourneyLogger.h"
#import "Journey.h"

@interface JourneyDetailViewController : UIViewController

@property (nonatomic) Journey *journey;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTitleLabel;



@end
