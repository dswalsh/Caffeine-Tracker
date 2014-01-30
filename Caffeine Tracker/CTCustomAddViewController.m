//
//  CTCustomAddViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/11/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTCustomAddViewController.h"

#import "CTEntry.h"
#import "CTAppDelegate.h"

@interface CTCustomAddViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;


@end

@implementation CTCustomAddViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.descriptionField becomeFirstResponder];
    
}
- (IBAction)descriptionChanged:(id)sender {
    if (self.descriptionField.hasText && self.caffeineField.hasText)
        [self.addButton setEnabled:true];
    else
        [self.addButton setEnabled:false];

}
- (IBAction)caffeineChanged:(id)sender {
    if (self.descriptionField.hasText && self.caffeineField.hasText)
        [self.addButton setEnabled:true];
    else
        [self.addButton setEnabled:false];
}

- (IBAction)clickAdd:(id)sender {
    CTEntry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"CTEntry" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [newEntry setValue:self.date forKey:@"date"];
    [newEntry setValue:self.descriptionField.text forKey:@"label"];
    [newEntry setValue:[NSNumber numberWithInt:self.caffeineField.text.intValue] forKey:@"caffeine"];
    
    NSError *err;
    [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&err];
    
    if ([self.sender isEqualToString:@"Today"])
        [self performSegueWithIdentifier:@"unwindToToday" sender:self];
    else if ([self.sender isEqualToString:@"Calendar"])
        [self performSegueWithIdentifier:@"unwindToHistory" sender:self];
}



@end
