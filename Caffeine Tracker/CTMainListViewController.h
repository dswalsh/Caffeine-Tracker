//
//  CTMainListViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/7/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTMainListViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property NSMutableArray *listItems;

- (void)reloadTable;

@end
