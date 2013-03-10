//
//  IGGalleryManager.m
//  IG
//
//  Created by Tom Berman on 07/03/2013.
//  Copyright (c) 2013 Tom Berman. All rights reserved.
//

#import "IGGalleryManager.h"

@implementation IGGalleryManager

//Update loaction device method

//UpdateLocationMethod (cutom code)

- (id)init
{
    self = [super init];
    if(self) {
        _artifacts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) setGalleryLocation:(NSString *)currentLongitude atLat:(NSString *)currentLatitude;
{
    
    NSLog(@" Gall Lat %@ Gall Long %@",currentLatitude,currentLongitude);
    
    //  Request Galery from CartoDB based on location details
    NSString *tmpurlString = [NSString stringWithFormat: @"http://tomb.cartodb.com/api/v2/sql?q=SELECT name FROM european_countries_export WHERE ST_Intersects( the_geom,ST_SetSRID( ST_POINT(%@, %@),4326))&api_key=6c488ad00f45400158ff329ea170e2db0c4c40a8", currentLongitude, currentLatitude ];
    
    NSString* urlString = [tmpurlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    
     NSLog(resultString);
}


@end
