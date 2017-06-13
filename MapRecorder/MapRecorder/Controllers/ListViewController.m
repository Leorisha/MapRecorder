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

@property (nonatomic) JourneyLogger *journeyLog;
@property (nonatomic) NSInteger selectedJourneyIndex;

@end

@implementation ListViewController
@synthesize listView;
@synthesize emptyListLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.journeyLog = [JourneyLogger sharedInstance];
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

-(void)prepareController {
    self.emptyListLabel.text = NSLocalizedString(@"empty_list_label", "");
    self.navigationItem.title = NSLocalizedString(@"list_title", "");
}

-(void)prepareTableView {
    UINib *cellNib = [UINib nibWithNibName:[ListTableViewCell cellIdentifier] bundle:nil];
    [self.listView registerNib:cellNib forCellReuseIdentifier:[ListTableViewCell cellIdentifier]];
    
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.estimatedRowHeight = 44.0;
    self.listView.rowHeight = UITableViewAutomaticDimension;
}

-(void)refreshTableView {
    if([self.journeyLog getJourneyLog].count == 0) {
        
        self.listView.hidden = YES;
        self.emptyListLabel.hidden = NO;
        
    } else {
        
        self.listView.hidden = NO;
        self.emptyListLabel.hidden = YES;
        
        [self.listView reloadData];
    }
}

// MARK: TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.journeyLog getJourneyLog].count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:[ListTableViewCell cellIdentifier]];
    Journey *journeyForCell = [[self.journeyLog getJourneyLog] objectAtIndex:indexPath.row];
    
    [listCell.title setText:journeyForCell.title];
    [listCell.subtitle setText:@""];
    
    return listCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedJourneyIndex = indexPath.row;
    [self performSegueWithIdentifier:@"SegueFromListToDetail" sender:self];
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"SegueFromListToDetail"]) {
        JourneyDetailViewController * journeyDetail = (JourneyDetailViewController*)segue.destinationViewController;
        journeyDetail.journey = [[self.journeyLog getJourneyLog] objectAtIndex:self.selectedJourneyIndex];
    }
}

@end
