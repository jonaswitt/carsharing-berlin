//
//  MQViewController.h
//  Carsharing
//
//  Created by Jonas Witt on 10.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class MQCar;

typedef enum {
    MQAnyLocation = 0,
    MQNoLocationOnly = 1,
    MQWithLocationOnly = 2,
} MQLocationStatus;

@interface MQCarMapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, UIToolbarDelegate>

@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic) MQCar *alertedCar;
@property (nonatomic, readonly) BOOL annotationsDisplayed;
@property (nonatomic, readonly) CLLocationManager *locationManager;

- (IBAction)centerUserLocation:(id)sender;
- (IBAction)refreshIfNeccessary;
- (IBAction)refresh:(id)sender;
- (void)refreshWithLocationStatus:(MQLocationStatus)status;

@end
