//
//  MQAppDelegate.h
//  Carsharing
//
//  Created by Jonas Witt on 10.04.12.
//  Copyright (c) 2012 metaquark. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MQCarMapViewController;

@interface MQCarsharingAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MQCarMapViewController *viewController;

#if !TARGET_IPHONE_SIMULATOR
- (void)handleCrashReport;
#endif

@end
