//
//  CTCustomAddViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/11/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCustomAddViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) NSDate *date;

@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *caffeineField;
@property (nonatomic) NSString *sender;

@end
