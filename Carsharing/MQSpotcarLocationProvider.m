//
//  MQSpotcarLocationProvider.m
//  Carsharing
//
//  Created by Jonas Witt on 09.11.14.
//  Copyright (c) 2014 metaquark. All rights reserved.
//

#import "MQSpotcarLocationProvider.h"
#import <Geo-Utilities/CLLocation+Navigation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFJSONUtilities.h>
#import "MQSpotCar.h"

@implementation MQSpotcarLocationProvider

- (void)refreshCarsAroundLocation:(CLLocation *)center withResultBlock:(MQCarLocationProviderResultBlock)resultBlock errorBlock:(MQCarLocationProviderErrorBlock)errorBlock
{
    static AFHTTPClient *client = nil;
    if (!client) {
        client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.spotcar.com/api/"]];
    }
    
    // https://www.spotcar.com/api/map/cars/?lat1=52.718268&lon1=13.208098&lat2=52.419173&lon2=13.572021
    
    CLLocationDistance radius = 3000;
    CLLocationCoordinate2D northWestCorner = [center kv_destinationCoordinateOnCirclePathUsingInitialBearing:315 andDistance:radius];
    CLLocationCoordinate2D southEastCorner = [center kv_destinationCoordinateOnCirclePathUsingInitialBearing:135 andDistance:radius];
    
    NSString *path = @"map/cars/";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@(northWestCorner.latitude), @"lat1", @(northWestCorner.longitude), @"lon1", @(southEastCorner.latitude), @"lat2", @(southEastCorner.longitude), @"lon2", nil];
    
    [client cancelAllHTTPOperationsWithMethod:@"GET" path:path];
    [client getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (resultBlock) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSError *error = nil;
                id JSON = AFJSONDecode(responseObject, &error);
                NSMutableArray *cars = [NSMutableArray array];
                for (NSDictionary *carInfo in JSON) {
                    double lat = [carInfo[@"lat"] doubleValue];
                    double lon = [carInfo[@"lon"] doubleValue];
                    NSString *name = carInfo[@"licencePlate"];
                    if (lat == 0 || lon == 0)
                        continue;
                    
                    MQSpotCar *car = [[MQSpotCar alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) name:name];
                    [cars addObject:car];
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
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"MQProviderSpotcarEnabled"];
}

- (BOOL)needsCenterLocation
{
    return YES;
}

@end
