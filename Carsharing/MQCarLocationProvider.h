//
//  MQCarLocationProvider.h
//  Carsharing
//
//  Created by Jonas Witt on 13.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^MQCarLocationProviderResultBlock)(NSArray *cars);
typedef void (^MQCarLocationProviderErrorBlock)(NSError *error);

@interface MQCarLocationProvider : NSObject

@property (nonatomic) NSArray *displayedCars;

- (void)refreshCarsWithResultBlock:(MQCarLocationProviderResultBlock)resultBlock errorBlock:(MQCarLocationProviderErrorBlock)errorBlock;
- (void)refreshCarsAroundLocation:(CLLocation *)center withResultBlock:(MQCarLocationProviderResultBlock)resultBlock errorBlock:(MQCarLocationProviderErrorBlock)errorBlock;

@end
