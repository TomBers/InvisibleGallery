/*==============================================================================
 Copyright (c) 2010-2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class EAGLView, QCARutils;

@interface ARViewController : UIViewController <CLLocationManagerDelegate>{
@public
    IBOutlet EAGLView *arView;  // the Augmented Reality view
    CGSize arViewSize;          // required view size

    
@protected
    QCARutils *qUtils;          // QCAR utils singleton class
@private
    UIView *parentView;         // Avoids unwanted interactions between UIViewController and EAGLView
    NSMutableArray* textures;   // Teapot textures
    BOOL arVisible;             // State of visibility of the view
}

@property (nonatomic, retain) IBOutlet EAGLView *arView;
@property (nonatomic) CGSize arViewSize;
@property (nonatomic, retain) CLLocationManager *locationManager;
           
- (void) handleARViewRotation:(UIInterfaceOrientation)interfaceOrientation;
- (void)freeOpenGLESResources;

@end
