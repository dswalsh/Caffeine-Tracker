//
//  CTAppDelegate.m
//  Caffeine Tracker
//
//  Created by Daniel Walsh on 10/24/13.
//  Copyright (c) 2013 Daniel Walsh. All rights reserved.
//

#import "CTAppDelegate.h"

#import "CTEntry.h"
#import "CTProduct.h"
#import "CTProduct.h"

@implementation CTAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInteger:250],[NSNumber numberWithBool:false],[NSNumber numberWithBool:false],[NSNumber numberWithBool:true],nil] forKeys:[NSArray arrayWithObjects:@"Goal",@"Metric",@"iCloud",@"firstRun",nil]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:dict];
    
    if ([[defaults objectForKey:@"firstRun"] boolValue]){
        [defaults synchronize];
        NSError *err;
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"products" ofType:@"json"];
        NSArray *products = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
        
        [products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CTProduct *product = [NSEntityDescription insertNewObjectForEntityForName:@"CTProduct" inManagedObjectContext:self.managedObjectContext];
            product.category = [obj objectForKey:@"category"];
            product.label = [obj objectForKey:@"label"];
            product.rate = [obj objectForKey:@"rate"];
            product.smallSizeLabel = [obj objectForKey:@"smallSizeLabel"];
            product.smallSizeAmount = [obj objectForKey:@"smallSizeAmount"];
            product.mediumSizeLabel = [obj objectForKey:@"mediumSizeLabel"];
            product.mediumSizeAmount = [obj objectForKey:@"mediumSizeAmount"];
            product.largeSizeLabel = [obj objectForKey:@"largeSizeLabel"];
            product.largeSizeAmount = [obj objectForKey:@"largeSizeAmount"];
        }];
        
        NSError *error;
        [self.managedObjectContext save:&error];
    }
    
    
    return YES;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Caffeine_Tracker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Caffeine_Tracker.sqlite"];
    
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
