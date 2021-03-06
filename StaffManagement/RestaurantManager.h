//
//  RestaurantManager.h
//  StaffManagement
//
//  Created by Derek Harasen on 2015-03-14.
//  Copyright (c) 2015 Derek Harasen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "Waiter.h"
#import "Shift.h"

@interface RestaurantManager : NSObject

+ (id)sharedManager;
- (Restaurant*)currentRestaurant;
- (Waiter *)newWaiter:(NSString *)name;
- (void)deleteWaiter:(Waiter *)waiter;
- (Shift *)newShiftFrom:(NSDate *)startTime to:(NSDate *)endTime for:(Waiter *)waiter;

@end
