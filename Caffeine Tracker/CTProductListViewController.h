//
//  CTProductListViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/10/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTProduct.h"

@interface CTProductListViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic)NSDate *date;
@property (nonatomic)NSString *category;
@property NSMutableArray *listItems;
@property (nonatomic)CTProduct *product;
@property (nonatomic)NSString *sender;

@end
