//
//  MQDriveNowCar.m
//  Carsharing
//
//  Created by Jonas Witt on 10.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQDriveNowCar.h"

@implementation MQDriveNowCar

@synthesize attributes=_attributes;

- (id)initWithAttributes:(NSDictionary *)attributes;
{
    if (!(self = [super init]))
        return nil;
    
    _attributes = attributes;
    
    NSDictionary *pos = [self.attributes objectForKey:@"position"];
    self.coordinate = CLLocationCoordinate2DMake([[pos objectForKey:@"latitude"] floatValue], [[pos objectForKey:@"longitude"] floatValue]);

    return self;
}

- (NSString *)title
{
    return [self.attributes objectForKey:@"personalName"];
}

- (NSString *)subtitle
{
    return @"DriveNow";
}

- (UIImage *)carIcon
{
    if ([[self.attributes objectForKey:@"model"] hasPrefix:@"MINI"])
        return [UIImage imageNamed:@"DriveNow"];
    return [UIImage imageNamed:@"DriveNow1er"];
}

- (BOOL)canLaunchApp
{
    return TRUE;
}

- (BOOL)launchApp
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"drivenow://"]];
}

- (NSURL *)appURL
{
    return [NSURL URLWithString:@"http://itunes.apple.com/de/app/id435719709"];
}

@end
