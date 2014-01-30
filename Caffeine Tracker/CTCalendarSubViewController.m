//
//  CTCalendarSubViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/11/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTCalendarSubViewController.h"

#import "CTCalendarViewController.h"
#import "TSQCalendarView.h"
#import "TSQCalendarCell.h"

@implementation CTCalendarSubViewController

- (void)loadView
{
    self.calendar = [[TSQCalendarView alloc] init];
    self.calendar.firstDate = [NSDate dateWithTimeIntervalSinceNow:-31536000];
    self.calendar.lastDate = [NSDate date];
    self.calendar.selectedDate = [NSDate date];
    self.calendar.backgroundColor = UIColor.whiteColor;
    self.calendar.pagingEnabled = YES;
    self.calendar.pinsHeaderToTop = NO;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    self.calendar.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
    self.view = self.calendar;
    [self.calendar setDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)setDate:(NSDate *)date
{
    self.calendar.selectedDate = date;
    [self.calendar scrollToDate:self.calendar.selectedDate animated:true];
}

#pragma mark calendar view delegate

- (BOOL)calendarView:(TSQCalendarView *)calendarView shouldSelectDate:(NSDate *)date{
    if ([date compare:[NSDate date]] == NSOrderedAscending)
        return true;
    else
        return false;
}

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date{
    [(CTCalendarViewController *)self.parentViewController changeDate:date];
}

@end
