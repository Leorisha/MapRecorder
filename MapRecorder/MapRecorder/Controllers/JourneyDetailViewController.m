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
@synthesize journey;
@synthesize startTimeLabel;
@synthesize endTimeLabel;
@synthesize startTitleLabel;
@synthesize endTitleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareValuesOnScreen];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareValuesOnScreen {
    
    // titles
    self.startTitleLabel.text = NSLocalizedString(@"start_time_title", "");
    self.endTitleLabel.text = NSLocalizedString(@"end_time_title", "");
    
    // values
    if (self.journey != nil && self.journey.startTime != nil && self.journey.endTime != nil && self.journey.title != nil) {
        self.navigationItem.title = self.journey.title;
        self.startTimeLabel.text = [self convert:self.journey.startTime];
        self.endTimeLabel.text = [self convert:self.journey.endTime];
    }
}

-(NSString*)convert:(NSDate*)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    return [df stringFromDate:date];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
