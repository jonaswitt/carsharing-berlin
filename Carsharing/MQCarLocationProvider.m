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

+ (void)initialize
{
    [super initialize];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"MQProviderCar2goEnabled" : @(TRUE), @"MQProviderDrivenowEnabled" : @(TRUE), @"MQProviderMulticityEnabled" : @(TRUE), @"MQProviderSpotcarEnabled": @(TRUE) }];
}

- (void)refreshCarsWithResultBlock:(MQCarLocationProviderResultBlock)resultBlock errorBlock:(MQCarLocationProviderErrorBlock)errorBlock
{
    [self refreshCarsAroundLocation:nil withResultBlock:resultBlock errorBlock:errorBlock];
}

- (void)refreshCarsAroundLocation:(CLLocation *)center withResultBlock:(MQCarLocationProviderResultBlock)resultBlock errorBlock:(MQCarLocationProviderErrorBlock)errorBlock
{
    
}

- (BOOL)enabled
{
    return TRUE;
}

- (BOOL)needsCenterLocation
{
    return NO;
}

@end
