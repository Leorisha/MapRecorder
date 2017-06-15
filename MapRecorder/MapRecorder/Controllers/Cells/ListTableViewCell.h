//
//  ListTableViewCell.h
//  MapRecorder
//
//  Created by Ana Neto on 12/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This is just a simple table view cell, didn't do anything fancy here.
 */
@interface ListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

+(NSString *)cellIdentifier;

@end
