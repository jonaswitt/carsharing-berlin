//
//  MQSpotCar.m
//  Carsharing
//
//  Created by Jonas Witt on 09.11.14.
//  Copyright (c) 2014 metaquark. All rights reserved.
//

#import "MQSpotCar.h"

@implementation MQSpotCar

@synthesize name=_name;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *)name
{
    if (!(self = [super init]))
        return nil;
    
    self.coordinate = coordinate;
    _name = name;
    
    return self;
}

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return @"Spotcar";
}

- (UIImage *)carIcon
{
    return [UIImage imageNamed:@"Spotcar"];
}

- (BOOL)canLaunchApp
{
    return TRUE;
}

- (BOOL)launchApp
{
    return NO;
}

- (NSURL *)appURL
{
    return [NSURL URLWithString:@"http://itunes.apple.com/de/app/id889943044"];
}

@end
