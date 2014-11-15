//
//  Carsharing_Tests.m
//  Carsharing Tests
//
//  Created by Jonas Witt on 15.11.14.
//  Copyright (c) 2014 metaquark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MQCar2GoLocationProvider.h"
#import "MQDriveNowLocationProvider.h"
#import "MQMulticityLocationProvider.h"
#import "MQSpotcarLocationProvider.h"

@interface Carsharing_Tests : XCTestCase

@end

@implementation Carsharing_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProviderHasAtLeastOneCar:(MQCarLocationProvider *)provider
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"fetch cars"];
    
    CLLocation *location = nil;
    if ([provider needsCenterLocation]) {
        location = [[CLLocation alloc] initWithLatitude:52.517 longitude:13.405];
    }
    [provider refreshCarsAroundLocation:location withResultBlock:^(NSArray *cars) {
        XCTAssertGreaterThan([cars count], 1);
        [expectation fulfill];
    } errorBlock:^(NSError *error) {
        XCTFail(@"An error occurred fetching cars: %@", error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testCar2go {
    MQCar2GoLocationProvider *provider = [[MQCar2GoLocationProvider alloc] init];
    [self testProviderHasAtLeastOneCar:provider];
}

- (void)testDriveNow {
    MQDriveNowLocationProvider *provider = [[MQDriveNowLocationProvider alloc] init];
    [self testProviderHasAtLeastOneCar:provider];
}

- (void)testMulticity {
    MQMulticityLocationProvider *provider = [[MQMulticityLocationProvider alloc] init];
    [self testProviderHasAtLeastOneCar:provider];
}

- (void)testSpotcar {
    MQSpotcarLocationProvider *provider = [[MQSpotcarLocationProvider alloc] init];
    [self testProviderHasAtLeastOneCar:provider];
}

@end
