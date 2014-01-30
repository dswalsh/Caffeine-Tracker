//
//  CTCategoryViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/5/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTCategoryViewController.h"

#import "CTProductListViewController.h"
#import "CTAppDelegate.h"
#import "CTCalendarViewController.h"
#import "CTTodayViewController.h"

@implementation CTCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.navigationItem backBarButtonItem.]
	
    self.category = @"";
    
}

- (IBAction)recentClick:(id)sender
{
    self.category = @"Recent";
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CTProduct" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lastUsed > %@ AND lastUsed < %@" argumentArray:[NSArray arrayWithObjects:[NSDate dateWithTimeIntervalSinceNow:-604800], [NSDate date], nil]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error;
    self.listItems = [NSMutableArray arrayWithArray:[[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:request error:&error]];
    [self.listItems sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastUsed" ascending:NO]]];
    
    
    [self performSegueWithIdentifier:@"productListSegue" sender:self];
    
}
- (IBAction)cancelClick:(id)sender
{
    if ([self.sender isEqualToString:@"Calendar"])
        [self performSegueWithIdentifier:@"unwindToHistory" sender:self];
    else if ([self.sender isEqualToString:@"Today"])
        [self performSegueWithIdentifier:@"unwindToToday" sender:self];
    
}

- (IBAction)favoritesClick:(id)sender
{
    
    self.category = @"Favorites";
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CTProduct" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite == %@",[NSNumber numberWithBool:true]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error;
    self.listItems = [NSMutableArray arrayWithArray:[[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:request error:&error]];
    [self.listItems sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"label" ascending:YES]]];
    
    [self performSegueWithIdentifier:@"productListSegue" sender:self];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get category from clicked cell
    self.category = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    // generate fetch request for category
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CTProduct" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category LIKE %@",self.category];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error;
    
    self.listItems = [NSMutableArray arrayWithArray:[[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] executeFetchRequest:request error:&error]];
    
    // sort results alphabetically
    [self.listItems sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"label" ascending:YES]]];
    
    // segue to product list
    [self performSegueWithIdentifier:@"productListSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CTProductListViewController *target = ((CTProductListViewController *)[segue destinationViewController]);
    if([segue.identifier isEqualToString:@"productListSegue"]){
        target.date = self.date;
        target.category = self.category;
        if ([target.category isEqualToString:@"Favorites"])
            [target.editButton setEnabled:true];
        else
            [target.editButton setEnabled:false];
        target.listItems = self.listItems;
        target.sender = self.sender;
    }
    else if ([segue.identifier isEqualToString:@"customSegue"]){
        target.date = self.date;
        target.sender = self.sender;
    }
}

- (IBAction)unwindToCategory:(UIStoryboardSegue *)segue{}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.typeTable)
        return 4;
    else
        return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (tableView == self.typeTable){
        switch (indexPath.row){
            case 0:
                cell.textLabel.text = @"Coffee";
                break;
            case 1:
                cell.textLabel.text = @"Tea";
                break;
            case 2:
                cell.textLabel.text = @"Soft drinks";
                break;
            case 3:
                cell.textLabel.text = @"Energy shots";
                break;
        }
        
    } else if (tableView == self.brandTable){
        switch (indexPath.row){
            case 0:
                cell.textLabel.text = @"AriZona";
                break;
            case 1:
                cell.textLabel.text = @"Bawls";
                break;
            case 2:
                cell.textLabel.text = @"Coca-Cola";
                
                break;
            case 3:
                cell.textLabel.text = @"Dr Pepper";
                break;
            case 4:
                cell.textLabel.text = @"Dunkin\' Donuts";
                break;
            case 5:
                cell.textLabel.text = @"Pepsi";
                break;
            case 6:
                cell.textLabel.text = @"Starbucks";
                break;
        }
    }
    
    return cell;
}


@end
