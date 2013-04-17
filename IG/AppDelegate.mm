//
//  AppDelegate.m
//  IG
//
//  Created by Tom Berman on 07/03/2013.
//  Copyright (c) 2013 Tom Berman. All rights reserved.
//

#import "AppDelegate.h"
#import "IGGalleryManager.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize locationManager;

IGGalleryManager *GM;
//This is where we get the Location Data on startup

//Setup location manager when app loads

//App delegate also needs to be a location manager delgate

//And Instatiate Model

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSString *currentLatitude = [[NSString alloc] initWithFormat:@"%g", locationManager.location.coordinate.latitude];
    NSString *currentLongitude = [[NSString alloc] initWithFormat:@"%g", locationManager.location.coordinate.longitude];
    
    
    [GM setGalleryLocation:currentLongitude atLat:currentLatitude];
}



- (void) setupLocationManager
{
// Create the manager object
self.locationManager = [CLLocationManager new];
    
locationManager.delegate = self;
// This is the most important property to set for the manager. It ultimately determines how the manager will
// attempt to acquire location and thus, the amount of power that will be consumed.
//locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
     [locationManager startMonitoringSignificantLocationChanges];
// Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];

self.locationManager.delegate = self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"Tutorial2" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    NSLog(@"Started");
    
    GM = [IGGalleryManager new];
    [self setupLocationManager];
    
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

@end
