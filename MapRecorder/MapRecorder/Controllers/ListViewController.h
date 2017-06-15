//
//  ListViewController.h
//  MapRecorder
//
//  Created by Ana Neto on 12/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 ListViewController is responsible for displaying the list of recorded journeys. It implements UITableViewDelegate and UITableViewDataSource protocols to control the tableview behaviour.
 */
@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *emptyListLabel;
@property (weak, nonatomic) IBOutlet UITableView *listView;

@end
