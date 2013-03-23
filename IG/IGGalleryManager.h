//
//  IGGalleryManager.h
//  IG
//
//  Created by Tom Berman on 07/03/2013.
//  Copyright (c) 2013 Tom Berman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface IGGalleryManager : NSObject

@property (nonatomic, retain) NSDictionary *artifacts;


-(void) setGalleryLocation:(NSString *)currentLongitude atLat:(NSString *)currentLatitude;

//- (void) addTargetName:(NSString *)theName atPath:(NSString *)thePath;

//- (void)deviceLocationUpdated:(CLLocation *)location;

@end
