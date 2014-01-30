//
//  CTCalendarViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/10/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTCalendarViewController.h"

#import "CTCategoryViewController.h"
#import "CTCalendarSubViewController.h"
#import "CTHistoryListViewController.h"
#import "CTAppDelegate.h"
#import "CTEntry.h"
#import "TSQCalendarView.h"

@implementation CTCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self changeDate:[NSDate date]];
    [(CTCalendarSubViewController *)self.childViewControllers[1] setDate:self.date];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self changeDate:self.date];
}


- (void)changeDate:(NSDate *)newDate{
    self.date = newDate;
    int dailyTotal = 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.date];
    NSDate *startDate = [calendar dateFromComponents:dateComponents];
    
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];
    NSDate *endDate = [calendar dateFromComponents:dateComponents];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@" argumentArray:[NSArray arrayWithObjects:startDate, endDate, nil]];
    
    NSFetchRequest *todayRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CTEntry" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [todayRequest setEntity:entity];
    [todayRequest setPredicate:datePredicate];
    NSError *error;
    
    NSArray *todayEntries = [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:todayRequest error:&error];
    
    for (CTEntry *entry in todayEntries)
        dailyTotal+=[entry.caffeine integerValue];
    
    self.totalLabel.text = [NSString stringWithFormat:@"%d mg",dailyTotal];
    ((CTHistoryListViewController *)self.childViewControllers[0]).listItems = [NSMutableArray arrayWithArray:todayEntries];
    [(CTHistoryListViewController *)self.childViewControllers[0] reloadTable];
}

- (void)setTableItems{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.date];
    NSDate *startDate = [calendar dateFromComponents:dateComponents];
    
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];
    NSDate *endDate = [calendar dateFromComponents:dateComponents];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@" argumentArray:[NSArray arrayWithObjects:startDate, endDate, nil]];
    
    NSFetchRequest *todayRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CTEntry" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [todayRequest setEntity:entity];
    [todayRequest setPredicate:datePredicate];
    NSError *error;
    
    ((CTHistoryListViewController *)self.childViewControllers[0]).listItems = [NSMutableArray arrayWithArray:[[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:todayRequest error:&error]];
    
}

- (void)reloadView{
    
    int dailyTotal = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.date];
    NSDate *startDate = [calendar dateFromComponents:dateComponents];
    
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];
    NSDate *endDate = [calendar dateFromComponents:dateComponents];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@" argumentArray:[NSArray arrayWithObjects:startDate, endDate, nil]];
    
    NSFetchRequest *todayRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CTEntry" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [todayRequest setEntity:entity];
    [todayRequest setPredicate:datePredicate];
    NSError *error;
    
    NSArray *todayEntries = [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:todayRequest error:&error];
    
    for (CTEntry *entry in todayEntries)
        dailyTotal+=[entry.caffeine integerValue];
    
    self.totalLabel.text = [NSString stringWithFormat:@"%d mg",dailyTotal];

    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"categorySegue"]){
        ((CTCategoryViewController *)[segue destinationViewController]).sender = @"Calendar";
        ((CTCategoryViewController *)[segue destinationViewController]).date = self.date;
    }
}

- (IBAction)unwindToCalendar: (UIStoryboardSegue *)segue {
    
}

@end
