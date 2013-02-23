/*==============================================================================
 Copyright (c) 2010-2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h> 

#import "ARViewController.h"
#import "QCARutils.h"
#import "EAGLView.h"
#import "Texture.h"

@interface ARViewController ()
- (void) unloadViewData;
- (void) handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation;
@end

@implementation ARViewController

@synthesize arView;
@synthesize arViewSize;
@synthesize locationManager;

bool runAlready = NO;
bool setTextures = NO;

- (id)init
{
    self = [super init];
    if (self) {
        qUtils = [QCARutils getInstance];
    }
    return self;
}

- (void)dealloc
{
    [self unloadViewData];
    [super dealloc];
}


- (void) unloadViewData
{
    // undo everything created in loadView and viewDidLoad
    // called from dealloc and viewDidUnload so has to be defensive
    
    // Release the textures array
    if (textures != nil)
    {
        [textures release];
        textures = nil;
    }
    
    [qUtils destroyAR];
    
    if (arView != nil)
    {
        [arView release];
        arView = nil;
    }
    
    if (parentView != nil)
    {
        [parentView release];
        parentView = nil;
    }
}


#pragma mark --- View lifecycle ---
// Implement loadView to create a view hierarchy programmatically, without using a nib.
// Invoked when UIViewController.view is accessed for the first time.
- (void)loadView
{
    NSLog(@"ARVC: loadView");
    
    // We are going to rotate our EAGLView by 90/270 degrees as the camera's idea of orientation is different to the screen,
    // so its width must be equal to the screen's height, and height to width
    CGRect viewBounds;
    viewBounds.origin.x = 0;
    viewBounds.origin.y = 0;
    viewBounds.size.width = arViewSize.height;
    viewBounds.size.height = arViewSize.width;
    arView = [[EAGLView alloc] initWithFrame: viewBounds];

    [self setTextures];
    
//    [arView setLocation:@"Bob"];
//    [arView setLocation:@"Bob"];
    
    // we add a parent view as EAGLView doesn't like being the immediate child of a VC
    parentView = [[UIView alloc] initWithFrame: viewBounds];
    [parentView addSubview:arView];
    self.view = parentView;
}

- (void) setupLocationManager
{
    // Create the manager object
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
    
    self.locationManager.delegate = self;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc] initWithFormat:@"%g", locationManager.location.coordinate.latitude];
    NSString *currentLongitude = [[NSString alloc] initWithFormat:@"%g", locationManager.location.coordinate.longitude];
    
    
    //  Request Galery from CartoDB based on location details
    NSString *tmpurlString = [NSString stringWithFormat: @"http://tomb.cartodb.com/api/v2/sql?q=SELECT name FROM european_countries_export WHERE ST_Intersects( the_geom,ST_SetSRID( ST_POINT(%@, %@),4326))&api_key=6c488ad00f45400158ff329ea170e2db0c4c40a8", currentLongitude, currentLatitude ];
    
    NSString* urlString = [tmpurlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSString* resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    
    if(! runAlready){
    [arView setLocation:resultString];
    }
    else runAlready = YES;
  
}

-(void) setTextures
{
    NSMutableArray * txtList = [NSMutableArray array];
    
    [txtList addObject: [NSString stringWithUTF8String:(char *)"icon_play.png"]];
    [txtList addObject: [NSString stringWithUTF8String:(char *)"icon_loading.png"]];
    [txtList addObject: [NSString stringWithUTF8String:(char *)"icon_error.png"]];
    [txtList addObject: [NSString stringWithUTF8String:(char *)"VuforiaSizzleReel_1.png"]];
    [txtList addObject: [NSString stringWithUTF8String:(char *)"VuforiaSizzleReel_2.png"]];
	[txtList addObject: [NSString stringWithUTF8String:(char *)"info.png"]];
    
    if(! setTextures){
        [arView setTextureList:txtList];
    }
    else setTextures = YES;
    
}


- (void)viewDidLoad
{
    NSLog(@"ARVC: viewDidLoad");
    
    // load the list of textures requested by the view, and tell it about them
    if (textures == nil)
        textures=[qUtils loadTextures:arView.textureList];
    [arView useTextures:textures];
   
    // set the view size for initialisation, and go do it...
    [qUtils createARofSize:arViewSize forDelegate:arView];
    arVisible = NO;
    
    [self setupLocationManager];
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"ARVC: viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated
{
    // resume here as in viewWillAppear the view hasn't always been stitched into the hierarchy
    // which means QCAR won't find our EAGLView
    NSLog(@"ARVC: viewDidAppear");
    if (arVisible == NO)
        [qUtils resumeAR];
    
    arVisible = YES;    
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"ARVC: viewDidDisappear");
    if (arVisible == YES)
        [qUtils pauseAR];
    
    // Be a good OpenGL ES citizen: ensure all commands have finished executing
    [arView finishOpenGLESCommands];
    
    arVisible = NO;
}


- (void)viewDidUnload
{
    NSLog(@"ARVC: viewDidUnload");
    
    [super viewDidUnload];
    
    [self unloadViewData];
}


- (void) handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation
{
    CGPoint centre, pos;
    NSInteger rot;

    // Set the EAGLView's position (its centre) to be the centre of the window, based on orientation
    centre.x = arViewSize.width / 2;
    centre.y = arViewSize.height / 2;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        NSLog(@"ARVC: Rotating to Portrait");
        pos = centre;
        rot = 90;
    }
    else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"ARVC: Rotating to Upside Down");        
        pos = centre;
        rot = 270;
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        NSLog(@"ARVC: Rotating to Landscape Left");        
        pos.x = centre.y;
        pos.y = centre.x;
        rot = 180;
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"ARParent: Rotating to Landscape Right");
        pos.x = centre.y;
        pos.y = centre.x;
        rot = 0;
    }

    arView.layer.position = pos;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rot * M_PI  / 180);
    arView.transform = rotate;  
}


// Free any OpenGL ES resources that are easily recreated when the app resumes
- (void)freeOpenGLESResources
{
    [arView freeOpenGLESResources];
}

@end
