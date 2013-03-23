//
//  IGGalleryManager.m
//  IG
//
//  Created by Tom Berman on 07/03/2013.
//  Copyright (c) 2013 Tom Berman. All rights reserved.
//

#import "IGGalleryManager.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@implementation IGGalleryManager

//Update loaction device method

//UpdateLocationMethod (cutom code)
bool updateMedia = true;

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
    
    if(updateMedia){
    NSLog(@" Gall Lat %@ Gall Long %@",currentLatitude,currentLongitude);
    NSError *error = nil;
    
    NSString *urlString = [NSString stringWithFormat: @"http://igss.herokuapp.com/?lat=%@&long=%@",currentLatitude,currentLongitude];
    NSURL *tmpURL = [NSURL URLWithString:urlString];
    
    
    NSData *jsonData = [NSData dataWithContentsOfURL: tmpURL];
    NSMutableArray *imgArray = [NSMutableArray new];
    
    
    
    if (jsonData) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (json) {
            
            
            NSArray *artContents = [json objectForKey:@"art"];
            for (NSDictionary *aItem in artContents) {
                
//                NSLog(@"ID : %@", [aItem objectForKey:@"id"]);
                NSDictionary *imgURLDic = [aItem objectForKey:@"image"];
                NSURL *imgURL = [imgURLDic objectForKey:@"url"];
              
                [imgArray addObject:imgURL];

//                NSLog(@"URL : %@", [imgURLDic objectForKey:@"url"]);
            }
            
        }
        
        NSLog(@"imgArray %d",imgArray.count);
        
        
        
    } else {
        // Handle Error
    }

      [self pullMediafromURL:imgArray];
        updateMedia = false;
    }

}

-(void) pullMediafromURL:(NSArray *)mediaArray;
{
    NSLog(@"Pulling %d Images",mediaArray.count);
    NSLog(@"Img Path %@",[mediaArray objectAtIndex:1]);
    
    
    NSURL *tst = [NSURL URLWithString:[mediaArray objectAtIndex:1]];
    NSURLRequest *request = [NSURLRequest requestWithURL:tst];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation new] initWithRequest:request];
  
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"filename"];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
    
    
//    [imageView setImageWithURL:[mediaArray objectAtIndex:0]];
//    for (int i = 0 ; i < mediaArray.count ; i++) {
//            NSLog(@"URL %d : %@",i, [mediaArray objectAtIndex:i]);
//        }
}


@end
