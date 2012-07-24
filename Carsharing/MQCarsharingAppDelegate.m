//
//  MQAppDelegate.m
//  Carsharing
//
//  Created by Jonas Witt on 10.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import "MQCarsharingAppDelegate.h"

#import "MQCarMapViewController.h"

#import <CrashReporter/CrashReporter.h>

@implementation MQCarsharingAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[MQCarMapViewController alloc] initWithNibName:@"MQCarMapViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
#if !TARGET_IPHONE_SIMULATOR
	PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
	NSError *error;
	
	// Check if we previously crashed
	if ([crashReporter hasPendingCrashReport])
		[self handleCrashReport];
    
	// Enable the Crash Reporter
	if (![crashReporter enableCrashReporterAndReturnError: &error])
		NSLog(@"Warning: Could not enable crash reporter: %@", error);
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#if !TARGET_IPHONE_SIMULATOR
- (void)handleCrashReport
{
	PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
	NSData *crashData;
	NSError *error;
	
	// Try loading the crash report
	crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
	if (crashData == nil) {
		NSLog(@"Could not load crash report: %@", error);
        [crashReporter purgePendingCrashReport];
        return;
	}
    
	NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://backend.metaquark.de/crashlogs/"]];
	[uploadRequest setHTTPMethod:@"POST"];
	[uploadRequest setHTTPBody:crashData];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:uploadRequest delegate:nil];
	
	// Purge the report
	[crashReporter purgePendingCrashReport];
	return;
}
#endif

@end
