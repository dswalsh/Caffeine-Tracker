//
//  CTProductListViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/10/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTProductListViewController.h"

#import "CTChooserViewController.h"
#import "CTProduct.h"
#import "CTAppDelegate.h"

@implementation CTProductListViewController

@synthesize listItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.category;
    
}

- (IBAction)clickEdit:(id)sender
{
    if (!self.tableView.editing){
        ((UIBarButtonItem *)sender).title = @"Done";
        self.tableView.editing = true;
    } else {
        ((UIBarButtonItem *)sender).title = @"Edit";
        self.tableView.editing = false;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.product = [self.listItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"chooserSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"chooserSegue"]){
        CTChooserViewController *target = (CTChooserViewController *)[segue destinationViewController];
        target.date = self.date;
        target.product = self.product;
        target.sender = self.sender;
    }
    
}

- (IBAction)unwindToProductList:(UIStoryboardSegue *)segue{}

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
    
    CTProduct *product = [self.listItems objectAtIndex:indexPath.row];
    cell.textLabel.text = product.label;
    
    return cell;
}

// support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ((CTProduct *)[listItems objectAtIndex:indexPath.row]).favorite = [NSNumber numberWithBool:false];
        NSError *err;
        [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&err];
        [listItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([self.listItems count] == 0){
            self.editButton.title = @"Edit";
            [self.tableView setEditing:false];
        }
    }
}

@end
