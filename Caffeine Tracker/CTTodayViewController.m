//
//  CTTodayViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/7/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTTodayViewController.h"

#import "CTEntry.h"
#import "CTAppDelegate.h"
#import "CTCategoryViewController.h"
#import "CTMainListViewController.h"
#import "CTHelpViewController.h"

@implementation CTTodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [((CTMainListViewController *)self.childViewControllers[0]) reloadTable];
    [self reloadView];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey: @"firstRun"] boolValue])
        [self performSegueWithIdentifier:@"helpSegue" sender:self];
}

-(IBAction)unwindToToday:(UIStoryboardSegue *)segue
{
    [self viewDidLoad];
}

- (void)reloadView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // generate predicate for current date
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *startDate = [calendar dateFromComponents:dateComponents];
    
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];
    NSDate *endDate = [calendar dateFromComponents:dateComponents];
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@" argumentArray:[NSArray arrayWithObjects:startDate, endDate, nil]];
    
    // retrieve entries for today
    NSFetchRequest *todayRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CTEntry" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [todayRequest setEntity:entity];
    [todayRequest setPredicate:datePredicate];
    NSError *error;
    
    NSArray *todayEntries = [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:todayRequest error:&error];
    
    // calculate daily total
    int dailyTotal = 0;
    for (CTEntry *entry in todayEntries)
        dailyTotal+=[entry.caffeine integerValue];
    
    // fill labels
    int percent = dailyTotal * 100 / [[defaults objectForKey:@"Goal"] intValue];
    NSMutableString *percentLabel = [NSMutableString stringWithFormat:@"%d",percent];
    [percentLabel appendString:@"%"];
    
    self.totalLabel.text = [NSString stringWithFormat:@"%d",dailyTotal];
    self.percentLabel.text = percentLabel;
    self.percentBar.progress = percent / 100.;
    if (percent <= 100){
        self.percentLabel.textColor = [UIColor colorWithRed:(16/256.) green:(163/256.) blue:(21/256.) alpha:1];
        self.percentBar.progressTintColor = [UIColor colorWithRed:(16/256.) green:(163/256.) blue:(21/256.) alpha:1];
    }else{
        self.percentLabel.textColor = [UIColor colorWithRed:(163/256.) green:0 blue:0 alpha:1];
        self.percentBar.progressTintColor = [UIColor colorWithRed:(163/256.) green:0 blue:0 alpha:1];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"categorySegue"]){
        ((CTCategoryViewController *)[segue destinationViewController]).sender = @"Today";
        ((CTCategoryViewController *)[segue destinationViewController]).date = [NSDate date];
    }
    else if ([segue.identifier isEqualToString:@"helpSegue"]){
        ((CTHelpViewController *)[segue destinationViewController]).total = self.totalLabel.text;
        ((CTHelpViewController *)[segue destinationViewController]).percent = self.percentLabel.text;
        ((CTHelpViewController *)[segue destinationViewController]).color = self.percentLabel.textColor;
    }
}

@end
