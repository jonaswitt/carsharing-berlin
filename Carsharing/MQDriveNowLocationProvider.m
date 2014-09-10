//
//  MQDriveNowLocationProvider.m
//  Carsharing
//
//  Created by Jonas Witt on 13.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQDriveNowLocationProvider.h"
#import <SBJson/SBJson4.h>
#import "MQDriveNowCar.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFJSONUtilities.h>

@implementation MQDriveNowLocationProvider

- (void)refreshCarsAroundLocation:(CLLocation *)center withResultBlock:(MQCarLocationProviderResultBlock)resultBlock errorBlock:(MQCarLocationProviderErrorBlock)errorBlock
{
    static AFHTTPClient *client = nil;
    if (!client) {
        client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://m.drive-now.com/php/metropolis/"]];
    }
    
    NSString *path = @"json.vehicle_filter";
    [client cancelAllHTTPOperationsWithMethod:@"POST" path:path];
    [client postPath:path parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"6099", @"cit", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (resultBlock) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSError *error = nil;
                id JSON = AFJSONDecode(responseObject, &error);
                NSMutableArray *cars = [NSMutableArray array];
                for (NSDictionary *carInfo in [[[JSON objectForKey:@"rec"] objectForKey:@"vehicles"] objectForKey:@"vehicles"]) {
                    [cars addObject:[[MQDriveNowCar alloc] initWithAttributes:carInfo]];
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

- (BOOL)enabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"MQProviderDrivenowEnabled"];
}

@end
