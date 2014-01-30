//
//  CTTrendsViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/7/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTTrendsViewController.h"

#import "PNChart.h"
#import "CTAppDelegate.h"
#import "CTEntry.h"

@implementation CTTrendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the value arrays
    [self loadDays];
    [self loadWeeks];
    [self loadMonths];
    
    // setup initial graph
    self.graphChooser.selectedSegmentIndex = 0;
    
    self.graphLabel.text = @"Totals from the past five days";
    self.lineChart = [[PNChart alloc] initWithFrame:CGRectMake(10, 175, SCREEN_WIDTH - 20, 300.0)];
    self.lineChart.clearsContextBeforeDrawing = true;
	self.lineChart.backgroundColor = [UIColor whiteColor];
    [self.lineChart setStrokeColor:[UIColor darkGrayColor]];
	[self.lineChart setXLabels:self.dayLabels];
	[self.lineChart setYValues:self.dayValues];
	[self.lineChart strokeChart];
    
    [self.view addSubview:self.lineChart];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self viewDidLoad];
}

- (void)loadDays{
    NSDate *currentDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents;
    NSDate *startDate;
    NSDate *endDate;
    NSPredicate *datePredicate;
    NSFetchRequest *request;
    NSEntityDescription *entity;
    NSArray *entries;
    self.dayLabels = [NSMutableArray arrayWithCapacity:5];
    self.dayValues = [NSMutableArray arrayWithCapacity:5];
    
    
    for (int i = 0 ; i < 5 ; i++){
        currentDate = [NSDate dateWithTimeIntervalSinceNow:-(86400 * (4 - i))];
        dateComponents = [calendar components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
        
        [self.dayLabels addObject:[NSString stringWithFormat:@"%d/%d",(int)dateComponents.month,(int)dateComponents.day]];
        
        startDate = [calendar dateFromComponents:dateComponents];
        
        [dateComponents setHour:23];
        [dateComponents setMinute:59];
        [dateComponents setSecond:59];
        endDate = [calendar dateFromComponents:dateComponents];
        datePredicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@" argumentArray:[NSArray arrayWithObjects:startDate, endDate, nil]];
        
        request = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"CTEntry" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
        [request setEntity:entity];
        [request setPredicate:datePredicate];

        NSError *error;
        entries = [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:request error:&error];
        
        int dailyTotal = 0;
        for (CTEntry *entry in entries)
            dailyTotal += [entry.caffeine intValue];
        [self.dayValues addObject:[NSNumber numberWithInt:dailyTotal]];
    }
    
}

- (void)loadWeeks{
    NSDate *currentDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents;
    NSDate *startDate;
    NSDate *endDate;
    NSPredicate *datePredicate;
    NSFetchRequest *request;
    NSEntityDescription *entity;
    NSArray *entries;
    self.weekLabels = [NSMutableArray arrayWithCapacity:5];
    self.weekValues = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 0 ; i < 5 ; i++){
        currentDate = [NSDate dateWithTimeIntervalSinceNow:-((604800 * (5 - i)) - 86400)];
        dateComponents = [calendar components:(NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
        [self.weekLabels addObject:[NSString stringWithFormat:@"%d/%d",(int)dateComponents.month,(int)dateComponents.day]];
        int weeklyTotal = 0;
        for(int j = 0 ; j < 7 ; j++){
            dateComponents = [calendar components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
            startDate = [calendar dateFromComponents:dateComponents];
            [dateComponents setHour:23];
            [dateComponents setMinute:59];
            [dateComponents setSecond:59];
            endDate = [calendar dateFromComponents:dateComponents];
            datePredicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@" argumentArray:[NSArray arrayWithObjects:startDate, endDate, nil]];
            
            request = [[NSFetchRequest alloc] init];
            entity = [NSEntityDescription entityForName:@"CTEntry" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
            [request setEntity:entity];
            [request setPredicate:datePredicate];
            
            NSError *error;
            entries = [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:request error:&error];
            
            int dailyTotal = 0;
            for (CTEntry *entry in entries)
                dailyTotal += [entry.caffeine intValue];
            weeklyTotal += dailyTotal;
            currentDate = [NSDate dateWithTimeInterval:86400 sinceDate:currentDate];
        }
        
        [self.weekValues addObject:[NSNumber numberWithInt:weeklyTotal / 7]];
    }

    
}

- (void)loadMonths{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents;
    NSDate *startDate;
    NSDate *endDate;
    NSPredicate *datePredicate;
    NSFetchRequest *request;
    NSEntityDescription *entity;
    NSArray *entries;
    self.monthLabels = [NSMutableArray arrayWithCapacity:5];
    self.monthValues = [NSMutableArray arrayWithCapacity:5];
    
    dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
    dateComponents.month -= 5;
    if (dateComponents.month < 1){
        dateComponents.year -= 1;
        dateComponents.month = 12 + dateComponents.month;
    }
    
    for(int i = 0 ; i < 5 ; i++){
        dateComponents.month++;
        if (dateComponents.month == 13){
            dateComponents.month = 1;
            dateComponents.year += 1;
        }
        switch(dateComponents.month){
            case 1:
                [self.monthLabels addObject:@"Jan."];
                break;
            case 2:
                [self.monthLabels addObject:@"Feb."];
                break;
            case 3:
                [self.monthLabels addObject:@"Mar."];
                break;
            case 4:
                [self.monthLabels addObject:@"Apr."];
                break;
            case 5:
                [self.monthLabels addObject:@"May"];
                break;
            case 6:
                [self.monthLabels addObject:@"June"];
                break;
            case 7:
                [self.monthLabels addObject:@"July"];
                break;
            case 8:
                [self.monthLabels addObject:@"Aug."];
                break;
            case 9:
                [self.monthLabels addObject:@"Sep."];
                break;
            case 10:
                [self.monthLabels addObject:@"Oct."];
                break;
            case 11:
                [self.monthLabels addObject:@"Nov."];
                break;
            case 12:
                [self.monthLabels addObject:@"Dec."];
                break;
        }
        startDate = [calendar dateFromComponents:dateComponents];
        dateComponents.day = [self daysInMonth:dateComponents.month inYear:dateComponents.year];
        endDate = [calendar dateFromComponents:dateComponents];
        dateComponents.day = 1;
        datePredicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@" argumentArray:[NSArray arrayWithObjects:startDate, endDate, nil]];
        
        request = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"CTEntry" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
        [request setEntity:entity];
        [request setPredicate:datePredicate];
        
        NSError *error;
        entries = [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:request error:&error];
        
        int monthlyTotal = 0;
        for (CTEntry *entry in entries)
            monthlyTotal += [entry.caffeine intValue];
        if (i < 4)
            [self.monthValues addObject:[NSNumber numberWithInt:monthlyTotal / [self daysInMonth:dateComponents.month inYear:dateComponents.year]]];
        else
            [self.monthValues addObject:[NSNumber numberWithInt:monthlyTotal / [calendar components:NSDayCalendarUnit fromDate:[NSDate date]].day]];
    }
    
}

- (NSInteger)daysInMonth:(NSInteger)month inYear:(NSInteger)year{
    switch (month){
        case 2:
            if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))
                return 29;
            else
                return 28;
        case 4:
            return 30;
        case 6:
            return 30;
       case 9:
            return 30;
        case 11:
            return 30;
    }
    return 31;
}

- (IBAction)chooseGraph:(id)sender
{
    switch (self.graphChooser.selectedSegmentIndex){
        case 0:
            self.graphLabel.text = @"Totals from the past five days";
            self.lineChart = [[PNChart alloc] initWithFrame:CGRectMake(10, 175, SCREEN_WIDTH - 20, 300.0)];
            self.lineChart.clearsContextBeforeDrawing = true;
            self.lineChart.backgroundColor = [UIColor whiteColor];
            [self.lineChart setStrokeColor:[UIColor darkGrayColor]];
            [self.lineChart setXLabels:self.dayLabels];
            [self.lineChart setYValues:self.dayValues];
            [self.view addSubview:self.lineChart];
            [self.lineChart strokeChart];
            break;
        case 1:
            self.graphLabel.text = @"Averages from the past five weeks";
            self.lineChart = [[PNChart alloc] initWithFrame:CGRectMake(10, 175, SCREEN_WIDTH - 20, 300.0)];
            self.lineChart.clearsContextBeforeDrawing = true;
            self.lineChart.backgroundColor = [UIColor whiteColor];
            [self.lineChart setStrokeColor:[UIColor darkGrayColor]];
            [self.lineChart setXLabels:self.weekLabels];
            [self.lineChart setYValues:self.weekValues];
            [self.view addSubview:self.lineChart];
            [self.lineChart strokeChart];
            break;
        case 2:
            self.graphLabel.text = @"Averages from the past five months";
            self.lineChart = [[PNChart alloc] initWithFrame:CGRectMake(10, 175, SCREEN_WIDTH - 20, 300.0)];
            self.lineChart.clearsContextBeforeDrawing = true;
            self.lineChart.backgroundColor = [UIColor whiteColor];
            [self.lineChart setStrokeColor:[UIColor darkGrayColor]];
            [self.lineChart setXLabels:self.monthLabels];
            [self.lineChart setYValues:self.monthValues];
            [self.view addSubview:self.lineChart];
            [self.lineChart strokeChart];
            break;
    }

}

@end
