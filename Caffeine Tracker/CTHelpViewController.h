//
//  CTHelpViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/12/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTHelpViewController : UIViewController

@property NSString *total;
@property NSString *percent;
@property UIColor *color;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;


@property (weak, nonatomic) IBOutlet UILabel *history1;
@property (weak, nonatomic) IBOutlet UILabel *history2;
@property (weak, nonatomic) IBOutlet UILabel *history3;

@property (weak, nonatomic) IBOutlet UILabel *welcome1;
@property (weak, nonatomic) IBOutlet UILabel *welcome2;

@property (weak, nonatomic) IBOutlet UILabel *add1;
@property (weak, nonatomic) IBOutlet UILabel *add2;

@property (weak, nonatomic) IBOutlet UILabel *settings1;
@property (weak, nonatomic) IBOutlet UILabel *settings2;
@property (weak, nonatomic) IBOutlet UILabel *settings3;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end
