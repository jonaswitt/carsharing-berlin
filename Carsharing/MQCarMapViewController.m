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
#import "MQCarAnnotationView.h"

@interface MQCarMapViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(52.517, 13.405), 15000, 15000)];
    
    self.carProviders = [NSArray arrayWithObjects:
                         [[MQCar2GoLocationProvider alloc] init], 
                         [[MQDriveNowLocationProvider alloc] init],
                         nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.mapView = nil;
    self.statusLabel = nil;
}


- (IBAction)centerUserLocation:(id)sender
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if (locationManager.location)
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate, 600, 600) animated:YES];
}

- (IBAction)refreshIfNeccessary
{
    if (!self.lastRefreshDate || [[NSDate date] timeIntervalSinceDate:self.lastRefreshDate] > 10 * 60) {
        [self refresh:nil];
    }
}

- (IBAction)refresh:(id)sender
{
    self.statusLabel.text = NSLocalizedString(@"Updating…", @"");

    __block NSMutableArray *remainingProviders = [NSMutableArray arrayWithArray:self.carProviders];
    __block BOOL displayedError = NO;
    for (MQCarLocationProvider *provider in self.carProviders) {
        if (self.annotationsDisplayed) 
            [self.mapView removeAnnotations:provider.displayedCars];
        provider.displayedCars = nil;
        [provider refreshLocationsWithResultBlock:^(NSArray *cars) {
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
    self.statusLabel.text = [NSString stringWithFormat:@"Last updated: %@", self.lastRefreshDate ? [formatter stringFromDate:self.lastRefreshDate] : NSLocalizedString(@"never", @"")]; 
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self refreshIfNeccessary];
    [self centerUserLocation:nil];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"App required", @"") message:NSLocalizedString(@"You need a seperate app to make a reservation for this vehicle. Would you like to download that app now?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Download", @""), nil];
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
