//
//  ListViewController.m
//  MapRecorder
//
//  Created by Ana Neto on 12/06/2017.
//  Copyright © 2017 Ana Neto. All rights reserved.
//

#import "ListViewController.h"
#import "JourneyManager.h"
#import "Journey.h"
#import "ListTableViewCell.h"

@interface ListViewController ()

@property (nonatomic) JourneyManager *journeyManager;

@end

@implementation ListViewController
@synthesize listView;
@synthesize emptyListLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.journeyManager = [JourneyManager sharedInstance];
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
    if(self.journeyManager.journeys.count == 0) {
        
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
    return self.journeyManager.journeys.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:[ListTableViewCell cellIdentifier]];
    Journey *journeyForCell = [self.journeyManager.journeys objectAtIndex:indexPath.row];
    
    [listCell.title setText:journeyForCell.title];
    [listCell.subtitle setText:@""];
    
    return listCell;
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
