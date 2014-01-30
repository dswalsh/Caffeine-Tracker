//
//  CTCategoryViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/5/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *typeTable;
@property (weak, nonatomic) IBOutlet UITableView *brandTable;
@property (nonatomic) NSString *category;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSMutableArray *listItems;
@property (nonatomic) NSString *sender;

@end
