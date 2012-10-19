//
//  MQMulticityLocationProvider.m
//  Carsharing
//
//  Created by Jonas Witt on 12.10.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQMulticityLocationProvider.h"
#import "AFNetworking.h"
#import "TouchXML.h"
#import "MQMulticityCar.h"

@implementation MQMulticityLocationProvider

- (void)refreshCarsAroundLocation:(CLLocation *)center withResultBlock:(MQCarLocationProviderResultBlock)resultBlock errorBlock:(MQCarLocationProviderErrorBlock)errorBlock
{
    if (center == nil) {
        errorBlock(nil);
        return;
    }
    
    static AFHTTPClient *client = nil;
    if (!client) {
        client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://52000000.dbcarsharing-buchung.de/"]];
    }
    
//    https://52000000.dbcarsharing-buchung.de/kundenbuchung/process.php?proc=buchanfrage_erg&geo_latitude=52.4849&geo_longitude=13.3642&instant_access=J&open_end=J&station_id=egal&klasse_id=egal&station_waschanged=1&klasse_waschanged=1&geo_radius=20
    
    NSDictionary *parameters = @{
    @"proc" : @"buchanfrage_erg",
    @"geo_latitude" : [NSString stringWithFormat:@"%f", center.coordinate.latitude],
    @"geo_longitude" : [NSString stringWithFormat:@"%f", center.coordinate.longitude],
    @"instant_access" : @"J",
    @"open_end" : @"J",
    @"station_id" : @"egal",
    @"klasse_id" : @"egal",
    @"station_waschanged" : @"1",
    @"klasse_waschanged" : @"1",
    @"geo_radius" : @"20"};
    
    NSString *path = @"kundenbuchung/process.php";
    [client cancelAllHTTPOperationsWithMethod:@"GET" path:path];
    [client getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (resultBlock) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSError *error = nil;
//                NSLog(@"xml: %@", [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding]);
                
                NSMutableData *data = [responseObject mutableCopy];
                [data replaceBytesInRange:NSMakeRange(44, 340) withBytes:NULL length:0];

                NSMutableArray *cars = [NSMutableArray array];
                CXMLDocument *doc = [[CXMLDocument alloc] initWithData:data encoding:NSISOLatin1StringEncoding options:0 error:nil];
                for (CXMLElement *node in [doc nodesForXPath:@"//buchAnfrageErg" error:nil]) {
                    double lat = [[[[node elementsForName:@"autoLatitude"] lastObject] stringValue] doubleValue];
                    double lon = [[[[node elementsForName:@"autoLongitude"] lastObject] stringValue] doubleValue];
                    NSString *charge = [[[node elementsForName:@"autoAkkuLadeStandProzent"] lastObject] stringValue];
                    NSString *name = [[[node elementsForName:@"autoKennz"] lastObject] stringValue];
                    if (lat == 0 || lon == 0)
                        continue;
                    
                    MQMulticityCar *car = [[MQMulticityCar alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) name:[NSString stringWithFormat:@"%@ (%@%%)", name, charge]];
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

@end
