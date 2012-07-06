//
//  MQCar2GoCar.h
//  Carsharing
//
//  Created by Jonas Witt on 13.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQCar.h"

@interface MQCar2GoCar : MQCar

@property (readonly, nonatomic) NSDictionary *attributes;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
