//
//  MQCarAnnotationView.h
//  Carsharing
//
//  Created by Jonas Witt on 06.07.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import <MapKit/MapKit.h>

@class MQCar;

@interface MQCarAnnotationView : MKAnnotationView

@property (nonatomic, readonly) MQCar *car;

- (void)updateIcon;

@end
