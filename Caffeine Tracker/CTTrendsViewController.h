//
//  CTTrendsViewController.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/7/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface CTTrendsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *graphChooser;
@property (weak, nonatomic) IBOutlet UILabel *graphLabel;
@property (nonatomic) PNChart *lineChart;
@property (nonatomic) NSMutableArray *dayLabels;
@property (nonatomic) NSMutableArray *dayValues;
@property (nonatomic) NSMutableArray *weekLabels;
@property (nonatomic) NSMutableArray *weekValues;
@property (nonatomic) NSMutableArray *monthLabels;
@property (nonatomic) NSMutableArray *monthValues;

@end
