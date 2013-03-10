//
//  AppDelegate.h
//  IG
//
//  Created by Tom Berman on 07/03/2013.
//  Copyright (c) 2013 Tom Berman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) CLLocationManager *locationManager;


@end
