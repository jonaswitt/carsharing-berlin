//
//  MQDriveNowCar.h
//  Carsharing
//
//  Created by Jonas Witt on 10.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQCar.h"

@interface MQDriveNowCar : MQCar

@property (readonly, nonatomic) NSDictionary *attributes;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
