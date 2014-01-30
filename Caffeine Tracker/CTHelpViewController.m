//
//  CTHelpViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/12/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTHelpViewController.h"

@interface CTHelpViewController ()

@end

@implementation CTHelpViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.totalLabel.text = self.total;
    self.percentLabel.text = self.percent;
    self.percentLabel.textColor = self.color;
    
	if ([[defaults objectForKey:@"firstRun"] boolValue]){
        self.button.titleLabel.text = @"Get started";
    } else{
        self.button.titleLabel.text = @"Done";
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:false] forKey:@"firstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
