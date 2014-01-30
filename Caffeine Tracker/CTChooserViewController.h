//
//  CTChooserViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/5/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTProduct.h"

@interface CTChooserViewController : UIViewController <UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeSegment;
@property (weak, nonatomic) IBOutlet UIPickerView *numberPicker;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISwitch *favoriteChooser;
@property (nonatomic) NSDate *date;
@property (nonatomic) CTProduct *product;
@property NSNumber *rate;
@property bool metric;
@property (nonatomic) NSString *sender;

@end
