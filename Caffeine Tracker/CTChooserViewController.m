//
//  CTChooserViewController.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/5/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTChooserViewController.h"

#import "CTProduct.h"
#import "CTEntry.h"
#import "CTAppDelegate.h"

@implementation CTChooserViewController

// perform initial setup of the view
- (void)viewDidLoad
{
    [super viewDidLoad];
    // sets unit to user default on initial opening of view
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![[defaults objectForKey:@"Metric"] boolValue]){
        self.metric = false;
    }
    else{
        self.metric = true;
    }
    
    self.favoriteChooser.on = [self.product.favorite boolValue];
    
    self.nameLabel.text = self.product.label;
    NSString *contentLabelText;
    
    [self.sizeSegment setTitle:self.product.smallSizeLabel forSegmentAtIndex:0];
    [self.sizeSegment setTitle:self.product.mediumSizeLabel forSegmentAtIndex:1];
    [self.sizeSegment setTitle:self.product.largeSizeLabel forSegmentAtIndex:2];
    self.sizeSegment.selectedSegmentIndex = 1 ;
    
    // if using US units
    if (!self.metric){
        self.rate = [NSNumber numberWithFloat:[self.product.rate floatValue]];
        [self.numberPicker selectRow:([self.product.mediumSizeAmount intValue] - 1) inComponent:0 animated:false];
        [self.numberPicker selectRow:0 inComponent:1 animated:true];
        contentLabelText = [NSString stringWithFormat:@"%.01F mg/oz",[self.rate floatValue]];
    }
    // if using metric units
    else{
        self.rate = [NSNumber numberWithFloat:([self.product.rate floatValue]/29.5)];
        [self.numberPicker selectRow:(([self.product.mediumSizeAmount floatValue] * 29.5) - 1) inComponent:0 animated:false];
        [self.numberPicker selectRow:1 inComponent:1 animated:true];
        contentLabelText = [NSString stringWithFormat:@"%.01F mg/mL",[self.rate floatValue]];
    }
    
    self.contentLabel.text = contentLabelText;
    self.totalLabel.text = [NSString stringWithFormat:@"%d mg",(int)(([self.numberPicker selectedRowInComponent:0] + 1) * [self.rate floatValue])];
    
    self.totalLabel.text = [NSString stringWithFormat:@"%d mg",[[NSNumber numberWithInt:([self.rate floatValue] * ([self.numberPicker selectedRowInComponent:0] + 1))] intValue]];
    
}

- (IBAction)clickFavorite:(id)sender {
    self.product.favorite = [NSNumber numberWithBool:self.favoriteChooser.on];
    self.favoriteChooser.on = [self.product.favorite boolValue];
    NSError *err;
    [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&err];
}


// return the number of columns to display in picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// return the # of rows in each picker component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if(component == 0){
        if (!self.metric)
            return 128;
        else
            return 1000;
    }
    else
        return 2;
}

// set text for picker items
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
        return [NSString stringWithFormat:@"%d",(int)(row + 1)];
    else{
        if (row == 0)
            return @"oz";
        else
            return @"mL";
    }
}

// handle a change in the selected value of the size segmented control
- (IBAction)segmentChange:(id)sender
{
    // if US units selected
    if (!self.metric){
        if (self.sizeSegment.selectedSegmentIndex == 0)
            [self.numberPicker selectRow:([self.product.smallSizeAmount intValue] - 1) inComponent:0 animated:true];
        else if (self.sizeSegment.selectedSegmentIndex == 1)
            [self.numberPicker selectRow:([self.product.mediumSizeAmount intValue] - 1) inComponent:0 animated:true];
        if (self.sizeSegment.selectedSegmentIndex == 2)
            [self.numberPicker selectRow:([self.product.largeSizeAmount intValue] - 1) inComponent:0 animated:true];
    }
    // if metric units selected
    else {
        if (self.sizeSegment.selectedSegmentIndex == 0)
            [self.numberPicker selectRow:(long)(([self.product.smallSizeAmount intValue] * 29.5) - 1) inComponent:0 animated:true];
        else if (self.sizeSegment.selectedSegmentIndex == 1)
            [self.numberPicker selectRow:(long)(([self.product.mediumSizeAmount intValue] * 29.5) - 1) inComponent:0 animated:true];
        if (self.sizeSegment.selectedSegmentIndex == 2)
            [self.numberPicker selectRow:(long)(([self.product.largeSizeAmount intValue] * 29.5) - 1) inComponent:0 animated:true];
    }
    
    self.totalLabel.text = [NSString stringWithFormat:@"%d mg",[[NSNumber numberWithInt:([self.rate floatValue] * ([self.numberPicker selectedRowInComponent:0] + 1))] intValue]];
}

// handle a change in the selected values of the picker
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // change between US/Metric on change in unit field
    NSInteger selectedRow = [pickerView selectedRowInComponent:0];
    if (component == 1){
        NSInteger selectedSegment = self.sizeSegment.selectedSegmentIndex;
        
        // if US units selected
        if (row == 0 && self.metric){
            selectedRow = (([self.numberPicker selectedRowInComponent:0] + 1) / 29.5) - 1;
            self.metric = false;
            self.rate = [NSNumber numberWithFloat:[self.product.rate floatValue]];
            [self.numberPicker reloadAllComponents];
            self.sizeSegment.selectedSegmentIndex = selectedSegment;
            [self.numberPicker selectRow:selectedRow inComponent:0 animated:false];
            
            
        }
        // if metric units selected
        else if (row == 1 && !self.metric){
            selectedRow =(([self.numberPicker selectedRowInComponent:0] + 1) * 29.5) - 1;
            self.metric = true;
            self.rate = [NSNumber numberWithFloat:([self.product.rate floatValue]/29.5)];
        }
        
        [self.numberPicker reloadAllComponents];
        self.sizeSegment.selectedSegmentIndex = selectedSegment;
        [self.numberPicker selectRow:selectedRow inComponent:0 animated:false];
    }
    
    self.totalLabel.text = [NSString stringWithFormat:@"%d mg",(int)((selectedRow + 1) * [self.rate floatValue])];
    
    // check if selected amount matches a size
    // if US units selected
    if (!self.metric){
        self.contentLabel.text = [NSString stringWithFormat:@"%.01f mg/oz",[self.rate floatValue]];
        if (selectedRow == [self.product.smallSizeAmount intValue] - 1)
            self.sizeSegment.selectedSegmentIndex = 0;
        else if (selectedRow == [self.product.mediumSizeAmount intValue] - 1)
            self.sizeSegment.selectedSegmentIndex = 1;
        else if (selectedRow == [self.product.largeSizeAmount intValue] - 1)
            self.sizeSegment.selectedSegmentIndex = 2;
        else
            self.sizeSegment.selectedSegmentIndex = 3;
    }
    // if metric units selected
    else{
        self.contentLabel.text = [NSString stringWithFormat:@"%.01F mg/mL",[self.rate floatValue]];
        if (selectedRow == (long)(([self.product.smallSizeAmount intValue] * 29.5) - 1))
            self.sizeSegment.selectedSegmentIndex = 0;
        else if (selectedRow == (long)(([self.product.mediumSizeAmount intValue] * 29.5) - 1))
            self.sizeSegment.selectedSegmentIndex = 1;
        else if (selectedRow == (long)(([self.product.largeSizeAmount intValue] * 29.5) - 1))
            self.sizeSegment.selectedSegmentIndex = 2;
        else
            self.sizeSegment.selectedSegmentIndex = 3;
    }

}

- (IBAction)clickAdd:(id)sender {
    NSString *unit;
    if (!self.metric)
        unit = @"oz";
    else
        unit = @"mL";
    
    // create new entry
    CTEntry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"CTEntry" inManagedObjectContext:[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [newEntry setValue:self.date forKey:@"date"];
    [newEntry setValue:[NSString stringWithFormat:@"%@, %d %@",self.product.label, (int)([self.numberPicker selectedRowInComponent:0] + 1), unit] forKey:@"label"];
    [newEntry setValue:[NSNumber numberWithInt:([self.numberPicker selectedRowInComponent:0] + 1) * [self.rate floatValue]] forKey:@"caffeine"];
    
    // update last used date for product
    self.product.lastUsed = [NSDate date];
    
    // save context
    NSError *err;
    [[(CTAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&err];
    
    if ([self.sender isEqualToString:@"Today"])
        [self performSegueWithIdentifier:@"unwindToToday" sender:self];
    else if ([self.sender isEqualToString:@"Calendar"])
        [self performSegueWithIdentifier:@"unwindToHistory" sender:self];
                                                                  
         
    
}

@end
