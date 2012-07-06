//
//  MQCarAnnotationView.m
//  Carsharing
//
//  Created by Jonas Witt on 06.07.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQCarAnnotationView.h"
#import "MQCar.h"

@implementation MQCarAnnotationView

- (MQCar *)car
{
    return (MQCar *)self.annotation;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    self.image = self.car.carIcon;
}

- (void)updateIcon
{
    self.image = self.car.carIcon;
}

@end
