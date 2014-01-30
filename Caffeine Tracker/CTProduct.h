//
//  CTProduct.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/9/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CTProduct : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * largeSizeAmount;
@property (nonatomic, retain) NSString * largeSizeLabel;
@property (nonatomic, retain) NSNumber * mediumSizeAmount;
@property (nonatomic, retain) NSString * mediumSizeLabel;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * smallSizeAmount;
@property (nonatomic, retain) NSString * smallSizeLabel;
@property (nonatomic, retain) NSDate *lastUsed;
@property (nonatomic, retain) NSNumber * favorite;

@end
