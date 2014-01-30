//
//  CTHistoryListViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/7/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTHistoryListViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *table;
@property NSMutableArray *listItems;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic) NSDate *date;

- (void)reloadTable;

@end
