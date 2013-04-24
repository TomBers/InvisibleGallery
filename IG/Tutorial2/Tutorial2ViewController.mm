
//  metaio SDK
//
//  Copyright metaio, GmbH 2012. All rights reserved.
//

#import "Tutorial2ViewController.h"
#import "EAGLView.h"
#import "IGGalleryManager.h"

@interface Tutorial2ViewController ()
- (void) setActiveModel: (int) modelIndex;
@end


@implementation Tutorial2ViewController


#pragma mark - UIViewController lifecycle


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:IGAssetPathNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        [self loadImage:notification.object];
    }];
    
    // load our tracking configuration
    NSString* trackingDataFile = [[NSBundle mainBundle] pathForResource:@"TrackingData_MarkerlessFast" ofType:@"xml" inDirectory:@"Assets2"];	
    
    
    // if you want to test the 3D tracking, please uncomment the line below and comment the line above
    //NSString* trackingDataFile = [[NSBundle mainBundle] pathForResource:@"TrackingData_ML3D" ofType:@"xml" inDirectory:@"Assets"];	
    
    
	if(trackingDataFile)
	{
		bool success = m_metaioSDK->setTrackingConfiguration([trackingDataFile UTF8String]);
		if( !success)
			NSLog(@"No success loading the tracking configuration");
	}
    
    
    
    // load content
 

    // load the movie plane
    NSString* moviePath = [[NSBundle mainBundle] pathForResource:@"water2" ofType:@"m4v" inDirectory:@"Assets2"];
    
	if(moviePath)
	{
        m_moviePlane =  m_metaioSDK->createGeometryFromMovie([moviePath UTF8String], false); // true for transparent movie
        if( m_moviePlane)
        {
            m_moviePlane->setScale(metaio::Vector3d(4.0,4.0,4.0));
            m_moviePlane->setRotation(metaio::Rotation(metaio::Vector3d(0, 0, -M_PI_2)));

        }
        else
        {
            NSLog(@"Error: could not load movie planes");            
        }
    }
    
    
    // start with image
    [self setActiveModel:0];
}

- (void)loadImage:(NSString *)imagePath
{
    
    if (imagePath)
    {
        m_imagePlane = m_metaioSDK->createGeometryFromImage([imagePath UTF8String]);
        if (m_imagePlane) {
            m_imagePlane->setScale(metaio::Vector3d(3.0,3.0,3.0));
            m_imagePlane->setVisible(false);
        }
        else NSLog(@"Error: could not load image plane");
    }
}



- (void)viewWillAppear:(BOOL)animated
{	
    [super viewWillAppear:animated];
}



- (void) viewDidAppear:(BOOL)animated
{	
	[super viewDidAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];	
}


- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [super viewDidUnload];
}


#pragma mark - App Logic
- (void) setActiveModel: (int) modelIndex
{
    switch ( modelIndex )
    {
     
            
        case 0:
            if(m_imagePlane)
            m_imagePlane->setVisible(true);
            
            // stop the movie
            m_moviePlane->setVisible(false);
            m_moviePlane->stopMovieTexture();
            break;
            
            
        case 1:
            if(m_imagePlane)
            m_imagePlane->setVisible(false);
            
            m_moviePlane->setVisible(true);
            m_moviePlane->startMovieTexture(true); // loop = true
            break;
    }
    
}

- (IBAction)onSegmentControlChanged:(UISegmentedControl*)sender 
{
    [self setActiveModel:sender.selectedSegmentIndex];
}

- (void)drawFrame
{
    [super drawFrame];
    
    if( !m_metaioSDK )
        return;
    
    // get all the detected poses/targets
    std::vector<metaio::TrackingValues> poses = m_metaioSDK->getTrackingValues();
    
    
    
    //if we have detected one, attach our metaioman to this coordinate system ID
    if(poses.size()){
        NSLog(@"Marker name %d",poses[0].coordinateSystemID);
    }
    
    
}


- (IBAction)onButtonpressed:(id)sender 
{
    
}



#pragma mark - Rotation handling


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // allow rotation in all directions
    return YES;
}


@end
