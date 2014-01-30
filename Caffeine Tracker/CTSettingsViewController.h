//
//  CTSettingsViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/7/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *goalField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *iCloudSwitch;

@end
