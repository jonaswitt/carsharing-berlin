//
//  MQViewController.h
//  Carsharing
//
//  Created by Jonas Witt on 10.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MQCar;

@interface MQCarMapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic) MQCar *alertedCar;
@property (nonatomic, readonly) BOOL annotationsDisplayed;

- (IBAction)centerUserLocation:(id)sender;
- (IBAction)refreshIfNeccessary;
- (IBAction)refresh:(id)sender;

@end
