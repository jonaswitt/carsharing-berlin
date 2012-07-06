//
//  MQCar2GoLocationProvider.m
//  Carsharing
//
//  Created by Jonas Witt on 13.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQCar2GoLocationProvider.h"
#import "SBJson.h"
#import "MQCar2GoCar.h"
#import "AFNetworking.h"
#import "AFJSONUtilities.h"

@implementation MQCar2GoLocationProvider

- (void)refreshLocationsWithResultBlock:(MQCarLocationProviderResultBlock)resultBlock errorBlock:(MQCarLocationProviderErrorBlock)errorBlock
{
    static AFHTTPClient *client = nil;
    if (!client) {
        client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.car2go.com/api/v2.1/"]];
    }
    
    NSString *path = @"vehicles";
    [client cancelAllHTTPOperationsWithMethod:@"GET" path:path];
    [client getPath:path parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"Berlin", @"loc", @"Mobilitaetsplattform", @"oauth_consumer_key", @"json", @"format", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (resultBlock) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSError *error = nil;
                id JSON = AFJSONDecode(operation.responseData, &error);
                NSMutableArray *cars = [NSMutableArray array];
                for (NSDictionary *carInfo in [JSON objectForKey:@"placemarks"]) {
                    [cars addObject:[[MQCar2GoCar alloc] initWithAttributes:carInfo]];
                }            
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultBlock(cars);                     
                });
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        } 
    }];
}

@end