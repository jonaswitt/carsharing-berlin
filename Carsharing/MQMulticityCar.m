//
//  MQMulticityCar.m
//  Carsharing
//
//  Created by Jonas Witt on 12.10.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQMulticityCar.h"

@implementation MQMulticityCar

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
    return @"Multicity";
}

- (UIImage *)carIcon
{
    return [UIImage imageNamed:@"Multicity"];
}

- (BOOL)canLaunchApp
{
    return TRUE;
}

- (BOOL)launchApp
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"multicity://"]];
}

- (NSURL *)appURL
{
    return [NSURL URLWithString:@"http://itunes.apple.com/de/app/id554074490"];
}

@end
