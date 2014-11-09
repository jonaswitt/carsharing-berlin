//
//  MQSpotCar.h
//  Carsharing
//
//  Created by Jonas Witt on 09.11.14.
//  Copyright (c) 2014 metaquark. All rights reserved.
//

#import "MQCar.h"

@interface MQSpotCar : MQCar

@property (readonly, nonatomic) NSString *name;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *)name;

@end
