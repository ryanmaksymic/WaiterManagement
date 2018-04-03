//
//  RestaurantManager.m
//  StaffManagement
//
//  Created by Derek Harasen on 2015-03-14.
//  Copyright (c) 2015 Derek Harasen. All rights reserved.
//

#import "RestaurantManager.h"
#import "AppDelegate.h"
#import "Shift.h"
#import "Waiter.h"
#import "Restaurant.h"

@interface RestaurantManager()

@property (nonatomic, retain) Restaurant *restaurant;

@end


@implementation RestaurantManager

+ (id)sharedManager {
    static RestaurantManager *sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (Restaurant*)currentRestaurant {
    if(self.restaurant == nil)
    {
        Restaurant *aRestaurant;
        NSError *error = nil;
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Restaurant"];
        NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
        
        if (results.count > 0) {
            aRestaurant = results[0];
        }
        else {
            NSEntityDescription *restaurantEntity = [NSEntityDescription entityForName:@"Restaurant" inManagedObjectContext:appDelegate.managedObjectContext];
            NSEntityDescription *waiterEntity = [NSEntityDescription entityForName:@"Waiter" inManagedObjectContext:appDelegate.managedObjectContext];
            aRestaurant = [[Restaurant alloc] initWithEntity:restaurantEntity insertIntoManagedObjectContext:appDelegate.managedObjectContext];
            
            Waiter *initialWaiter = [[Waiter alloc]initWithEntity:waiterEntity insertIntoManagedObjectContext:appDelegate.managedObjectContext];
            initialWaiter.name = NSLocalizedString(@"John Smith", nil);
            [aRestaurant addStaffObject:initialWaiter];
            
            [appDelegate.managedObjectContext save:&error];
        }
        self.restaurant = aRestaurant;
    }
    return self.restaurant;
}

- (Waiter *)newWaiter:(NSString *)name {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSEntityDescription *waiterEntity = [NSEntityDescription entityForName:@"Waiter" inManagedObjectContext:appDelegate.managedObjectContext];
    Waiter *newWaiter = [[Waiter alloc]initWithEntity:waiterEntity insertIntoManagedObjectContext:appDelegate.managedObjectContext];
    newWaiter.name = NSLocalizedString(name, nil);
    Restaurant *restaurant = [[RestaurantManager sharedManager] currentRestaurant];
    [restaurant addStaffObject:newWaiter];
    NSError *error = nil;
    [appDelegate.managedObjectContext save:&error];
    return newWaiter;
}

- (void)deleteWaiter:(Waiter *)waiter {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.managedObjectContext deleteObject:waiter];
    NSError *error = nil;
    [appDelegate.managedObjectContext save:&error];
}

- (Shift *)newShiftFrom:(NSDate *)startTime to:(NSDate *)endTime for:(Waiter *)waiter {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSEntityDescription *shiftEntity = [NSEntityDescription entityForName:@"Shift" inManagedObjectContext:appDelegate.managedObjectContext];
    Shift *newShift = [[Shift alloc] initWithEntity:shiftEntity insertIntoManagedObjectContext:appDelegate.managedObjectContext];
    newShift.startTime = startTime;
    newShift.endTime = endTime;
    [waiter addShiftsObject:newShift];
    NSError *error = nil;
    [appDelegate.managedObjectContext save:&error];
    return newShift;
}

@end
