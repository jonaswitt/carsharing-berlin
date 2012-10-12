//
//  MQMulticityCar.h
//  Carsharing
//
//  Created by Jonas Witt on 12.10.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQCar.h"

@interface MQMulticityCar : MQCar

@property (readonly, nonatomic) NSString *name;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *)name;

@end
