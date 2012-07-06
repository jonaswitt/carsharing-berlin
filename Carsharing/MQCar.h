//
//  MQCar.h
//  Carsharing
//
//  Created by Jonas Witt on 10.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MQCar : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

- (UIImage *)carIcon;
- (BOOL)canLaunchApp;
- (BOOL)launchApp;
- (NSURL *)appURL;

@end
