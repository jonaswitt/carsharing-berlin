//
//  MQViewController.m
//  Carsharing
//
//  Created by Jonas Witt on 10.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQCarMapViewController.h"
#import "SBJson.h"
#import "MQDriveNowCar.h"
#import "MQCar2GoLocationProvider.h"
#import "MQDriveNowLocationProvider.h"
#import "MQMulticityLocationProvider.h"
#import "MQCarAnnotationView.h"

@interface MQCarMapViewController () {
    
    BOOL initialLocationBasedUpdateStarted;
    BOOL initialZoomedIn;
    NSMutableArray *remainingProviders;
    
}

@property (strong, nonatomic) NSArray *carProviders;
@property (strong, nonatomic) NSDate *lastRefreshDate;
@property (nonatomic) BOOL annotationsDisplayed;

@end

@implementation MQCarMapViewController

@synthesize mapView = _mapView;
@synthesize statusLabel = _statusLabel;
@synthesize carProviders = _carProviders;
@synthesize lastRefreshDate = _lastRefreshDate;
@synthesize alertedCar = _alertedCar;
@synthesize annotationsDisplayed=_annotationsDisplayed;
@synthesize locationManager=_locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(52.517, 13.405), 15000, 15000)];
    
    self.carProviders = [NSArray arrayWithObjects:
                         [[MQCar2GoLocationProvider alloc] init], 
                         [[MQDriveNowLocationProvider alloc] init],
                         [[MQMulticityLocationProvider alloc] init],
                         nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.mapView = nil;
    self.statusLabel = nil;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (IBAction)centerUserLocation:(id)sender
{
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorized:
        default: {
            if (self.locationManager.location)
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 600, 600) animated:YES];
            break;
        }
            
        case kCLAuthorizationStatusRestricted:
            // we can't do much in this case
            break;
            
        case kCLAuthorizationStatusDenied: {
            if (sender) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your Location", @"") message:NSLocalizedString(@"You have disabled location services for this application. Please enable location services in system settings to locate your position on the map.", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
                break;                
            }
        }
    }
    
}

- (IBAction)refreshIfNeccessary
{
    if (!self.lastRefreshDate || [[NSDate date] timeIntervalSinceDate:self.lastRefreshDate] > 10 * 60) {
        [self refresh:nil];
    }
}

- (IBAction)refresh:(id)sender
{
    [self refreshWithLocationStatus:MQAnyLocation];
}

- (void)refreshWithLocationStatus:(MQLocationStatus)status
{
    if (!remainingProviders)
        remainingProviders = [NSMutableArray array];
    __block BOOL displayedError = NO;
    
    CLLocation *center = nil;
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(self.mapView.visibleMapRect);
    CLLocationDistance span = MIN(region.span.latitudeDelta, region.span.longitudeDelta * cos(region.center.latitude / 180.0 * M_PI)) * 111000;
    if (span < 5000)
        center = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
    if (center && (status & MQNoLocationOnly) == 0)
        initialLocationBasedUpdateStarted = YES;
    
    for (MQCarLocationProvider *provider in self.carProviders) {
        if ((status & MQNoLocationOnly) && provider.needsCenterLocation)
            continue;
        if ((status & MQWithLocationOnly) && !provider.needsCenterLocation)
            continue;
     
        if (self.annotationsDisplayed)
            [self.mapView removeAnnotations:provider.displayedCars];
        provider.displayedCars = nil;

        if (!provider.enabled)
            continue;
        if (!center && provider.needsCenterLocation)
            continue;
        
        NSLog(@"Updating locations using %@ around center: %@", NSStringFromClass([provider class]), center);
        [remainingProviders addObject:provider];
        [provider refreshCarsAroundLocation:center withResultBlock:^(NSArray *cars) {
            provider.displayedCars = cars;
            if (self.annotationsDisplayed) 
                [self.mapView addAnnotations:cars];  
            
            [remainingProviders removeObject:provider];
            if ([remainingProviders count] == 0)
                self.lastRefreshDate = [NSDate date];
        } errorBlock:^(NSError *error) {
            if (!displayedError) {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [errorAlert show];
                displayedError = YES;                
            }

            [remainingProviders removeObject:provider];
            if ([remainingProviders count] == 0) 
                self.lastRefreshDate = self.lastRefreshDate;
        }];
    }
    if ([remainingProviders count] > 0)
        self.statusLabel.text = NSLocalizedString(@"Updating…", @"");
}

- (void)setLastRefreshDate:(NSDate *)lastRefreshDate
{
    _lastRefreshDate = lastRefreshDate;
    
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    self.statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last updated: %@", @""), self.lastRefreshDate ? [formatter stringFromDate:self.lastRefreshDate] : NSLocalizedString(@"never", @"")];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self centerUserLocation:nil];
    [self refreshIfNeccessary];
    
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(self.mapView.visibleMapRect);
    CLLocationDistance span = MIN(region.span.latitudeDelta, region.span.longitudeDelta * cos(region.center.latitude / 180.0 * M_PI)) * 111000;
    if (span > 2000 && !initialZoomedIn) {
        initialZoomedIn = YES;
        [self centerUserLocation:nil];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateRegion region = self.mapView.region;
    CLLocationDistance minSpan = MIN(region.span.latitudeDelta, region.span.longitudeDelta * cos(region.center.latitude / 180 * M_PI)) * 111000;
    BOOL shouldDisplayAnnotations = minSpan < 4000;
    if (shouldDisplayAnnotations != self.annotationsDisplayed) {
        if (shouldDisplayAnnotations) {
            for (MQCarLocationProvider *provider in self.carProviders)
                [self.mapView addAnnotations:provider.displayedCars];            
        }
        else {
            for (MQCarLocationProvider *provider in self.carProviders)
                [self.mapView removeAnnotations:provider.displayedCars];
        }
        self.annotationsDisplayed = shouldDisplayAnnotations;
    }
    
    CLLocationDistance span = MIN(region.span.latitudeDelta, region.span.longitudeDelta * cos(region.center.latitude / 180.0 * M_PI)) * 111000;
    if (!initialLocationBasedUpdateStarted && span < 5000) {
        [self refreshWithLocationStatus:MQWithLocationOnly];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation respondsToSelector:@selector(carIcon)]) {
        static NSString *identifier = @"CarView";
        MQCarAnnotationView *view = (MQCarAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!view) {
            view = [[MQCarAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        return view;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
            view.canShowCallout = NO;
            continue;
        }
        if (![view.annotation isKindOfClass:[MQCar class]]) {
            continue;
        }
        view.canShowCallout = YES;
        MQCar *car = (MQCar *)view.annotation;
        if ([car canLaunchApp])
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (![view.annotation respondsToSelector:@selector(launchApp)])
        return;
    MQCar *car = (MQCar *)view.annotation;
    if (![car launchApp] && [car appURL]) {
        self.alertedCar = (MQCar *)view.annotation;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"App required", @"") message:NSLocalizedString(@"You need a separate app to make a reservation for this vehicle. Would you like to view that app in the App Store now?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Download", @""), nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [[UIApplication sharedApplication] openURL:self.alertedCar.appURL];
    }
    self.alertedCar = nil;
}

@end
