//
//  CTSettingsViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/7/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTSettingsViewController.h"

@implementation CTSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.goalField.text = [NSString stringWithFormat:@"%d",[[defaults objectForKey:@"Goal"] intValue]];
    
    if ([[defaults objectForKey:@"Metric"] boolValue])
        self.unitSwitch.selectedSegmentIndex = 1;
    else
        self.unitSwitch.selectedSegmentIndex = 0;
    self.iCloudSwitch.on = [[defaults objectForKey:@"iCloud"] boolValue];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],nil];
    [numberToolbar sizeToFit];
    self.goalField.inputAccessoryView = numberToolbar;
}
- (IBAction)iconButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.icons8.com"]];
}

- (IBAction)linkButton:(id)sender
{
    if (((UIButton *)sender).tag == 1)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nlm.nih.gov/medlineplus/ency/article/002445.htm"]];
    else if (((UIButton *)sender).tag == 2)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mayoclinic.com/health/caffeine/NU00600"]];
    else if (((UIButton *)sender).tag == 3)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hc-sc.gc.ca/fn-an/securit/addit/caf/food-caf-aliments-eng.php"]];
}

- (IBAction)textDone:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:[self.goalField.text intValue]] forKey:@"Goal"];
    [defaults synchronize];
 }
- (IBAction)switchUnits:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.unitSwitch.selectedSegmentIndex == 0)
        [defaults setObject:[NSNumber numberWithBool:false] forKey:@"Metric"];
    else
        [defaults setObject:[NSNumber numberWithBool:true] forKey:@"Metric"];
    [defaults synchronize];
}

- (IBAction)enableICloud:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:self.iCloudSwitch.on] forKey:@"iCloud"];
    [defaults synchronize];
    
}

-(void)cancelNumberPad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.goalField.text = [NSString stringWithFormat:@"%d",[[defaults objectForKey:@"Goal"] intValue]];
    [self.goalField resignFirstResponder];
}

-(void)doneWithNumberPad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:[self.goalField.text intValue]] forKey:@"Goal"];
    [defaults synchronize];
    [self.goalField resignFirstResponder];
}

@end
