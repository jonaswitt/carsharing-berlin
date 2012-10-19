//
//  MQCarLocationProvider.m
//  Carsharing
//
//  Created by Jonas Witt on 13.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQCarLocationProvider.h"

@implementation MQCarLocationProvider

@synthesize displayedCars=_displayedCars;

- (void)refreshCarsWithResultBlock:(MQCarLocationProviderResultBlock)resultBlock errorBlock:(MQCarLocationProviderErrorBlock)errorBlock
{
    [self refreshCarsAroundLocation:nil withResultBlock:resultBlock errorBlock:errorBlock];
}

- (void)refreshCarsAroundLocation:(CLLocation *)center withResultBlock:(MQCarLocationProviderResultBlock)resultBlock errorBlock:(MQCarLocationProviderErrorBlock)errorBlock
{
    
}

@end
