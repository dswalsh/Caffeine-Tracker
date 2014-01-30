//
//  CTMainListViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/7/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTMainListViewController.h"

#import "CTEntry.h"
#import "CTAppDelegate.h"
#import "CTTodayViewController.h"

@implementation CTMainListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *startDate = [calendar dateFromComponents:dateComponents];
    
    [dateComponents setHour:23];
    [dateComponents setMinute:59];
    [dateComponents setSecond:59];
    NSDate *endDate = [calendar dateFromComponents:dateComponents];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CTEntry" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@" argumentArray:[NSArray arrayWithObjects:startDate, endDate, nil]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error;
    self.listItems = [NSMutableArray arrayWithArray:[[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:request error:&error]];
    
}

- (IBAction)clickEdit:(id)sender
{
    [self.table setEditing:!self.table.editing animated:true];
    if (self.table.editing){
        ((UIBarButtonItem *)sender).title = @"Done";
    }
    else{
        ((UIBarButtonItem *)sender).title = @"Edit";
    }
}


- (void)reloadTable
{
    self.editButton.title = @"Edit";
    self.tableView.editing = false;
    [self viewDidLoad];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CTEntry *entry = [self.listItems objectAtIndex:indexPath.row];
    cell.textLabel.text = entry.label;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d mg",[entry.caffeine intValue]];
    
    return cell;
}


// support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] deleteObject:self.listItems[indexPath.row]];
        NSError *error;
        [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&error];
        [(CTTodayViewController*)self.parentViewController reloadView];
        [self.listItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([self.listItems count] == 0){
            [self.table setEditing:false];
            self.editButton.title = @"Edit";
        }
            
    }
}

@end
