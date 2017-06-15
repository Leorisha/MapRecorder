//
//  ListViewController.m
//  MapRecorder
//
//  Created by Ana Neto on 12/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "ListViewController.h"
#import "JourneyLogger.h"
#import "Journey.h"
#import "ListTableViewCell.h"
#import "JourneyDetailViewController.h"

@interface ListViewController ()

@property (nonatomic) JourneyLogger *journeyLogger;
@property (nonatomic) NSInteger selectedJourneyIndex;

@end

@implementation ListViewController
@synthesize listView, emptyListLabel;

#pragma mark - ViewController lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.journeyLogger = [JourneyLogger sharedInstance];
    
    [self prepareController];
    [self prepareTableView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Auxiliar methods

/**
 This is where the necessary localization is made.
 */
-(void)prepareController {
    self.emptyListLabel.text = NSLocalizedString(@"empty_list_label", "");
    self.navigationItem.title = NSLocalizedString(@"list_title", "");
}

/**
 This is where the tableView is prepared for use - the cells are registered the delegate and data source are assignated here too, as welll as other tableview configurations, like row height.
 */
-(void)prepareTableView {
    UINib *cellNib = [UINib nibWithNibName:[ListTableViewCell cellIdentifier] bundle:nil];
    [self.listView registerNib:cellNib forCellReuseIdentifier:[ListTableViewCell cellIdentifier]];
    
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.estimatedRowHeight = 44.0;
    self.listView.rowHeight = UITableViewAutomaticDimension;
}

/**
 This method ensure that no empty table is displayed. If there is no recorded journeys, an error message is displayed on the center of the screen.
 */
-(void)refreshTableView {
    if([self.journeyLogger getLog].count == 0) {
        
        self.listView.hidden = YES;
        self.emptyListLabel.hidden = NO;
        
    } else {
        
        self.listView.hidden = NO;
        self.emptyListLabel.hidden = YES;
        
        [self.listView reloadData];
    }
}


#pragma mark - TableViewDelegate and TableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.journeyLogger getLog].count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:[ListTableViewCell cellIdentifier]];
    Journey *journeyForCell = [[self.journeyLogger getLog] objectAtIndex:indexPath.row];
    
    [listCell.title setText:journeyForCell.title];
    [listCell.subtitle setText:@""];
    
    return listCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If a cell is selected open the JourneyDetailViewController.
    
    self.selectedJourneyIndex = indexPath.row;
    [self performSegueWithIdentifier:@"SegueFromListToDetail" sender:self];
    
}

#pragma mark - Navigation methods

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"SegueFromListToDetail"]) {
        JourneyDetailViewController * journeyDetail = (JourneyDetailViewController*)segue.destinationViewController;
        journeyDetail.journey = [[self.journeyLogger getLog] objectAtIndex:self.selectedJourneyIndex];
    }
}

@end
