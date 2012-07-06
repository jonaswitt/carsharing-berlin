//
//  MQCar2GoCar.m
//  Carsharing
//
//  Created by Jonas Witt on 13.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQCar2GoCar.h"

@implementation MQCar2GoCar

@synthesize attributes=_attributes;

- (id)initWithAttributes:(NSDictionary *)attributes;
{
    if (!(self = [super init]))
        return nil;
    
    _attributes = attributes;
    
    NSArray *pos = [self.attributes objectForKey:@"coordinates"];
    self.coordinate = CLLocationCoordinate2DMake([[pos objectAtIndex:1] floatValue], [[pos objectAtIndex:0] floatValue]);

    return self;
}

- (NSString *)title
{
    return [self.attributes objectForKey:@"name"];
}

- (NSString *)subtitle
{
    return @"Car2Go";
}

- (UIImage *)carIcon
{
    return [UIImage imageNamed:@"Car2Go"];
}

- (BOOL)canLaunchApp
{
    return TRUE;
}

- (BOOL)launchApp
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"car2go://"]];
}

- (NSURL *)appURL
{
    return [NSURL URLWithString:@"http://itunes.apple.com/de/app/id514921710"];
}

@end
