//
//  CTCalendarViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/10/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCalendarViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (nonatomic) NSDate *date;
@property (weak, nonatomic) IBOutlet UIView *calendarContainer;
@property (weak, nonatomic) IBOutlet UIView *listContainer;

- (void)changeDate:(NSDate *)newDate;
- (void)reloadView;

@end
