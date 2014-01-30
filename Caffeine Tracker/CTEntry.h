//
//  CTEntry.h
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 11/9/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CTEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * caffeine;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * label;

@end
