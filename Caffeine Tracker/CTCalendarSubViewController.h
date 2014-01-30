//
//  CTCalendarSubViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/11/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSQCalendarView.h"

@interface CTCalendarSubViewController : UIViewController <TSQCalendarViewDelegate>

@property (nonatomic)TSQCalendarView *calendar;
- (void)setDate:(NSDate *)date;
@end
