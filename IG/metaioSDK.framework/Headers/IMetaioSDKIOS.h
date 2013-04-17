// Copyright 2007-2012 metaio GmbH. All rights reserved.
#ifndef ___AS_IMETAIOSDKIOS_H_INCLUDED___
#define ___AS_IMETAIOSDKIOS_H_INCLUDED___


#include "IMetaioSDK.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

template class std::vector<metaio::TrackingValues>;        // explicit instantiation


@class AVCaptureVideoPreviewLayer;
@class IGeometry;
@class NSString;
@class NSObject;

/** Set to of functions to handle metaio SDK callbacks
*/
@protocol MetaioSDKDelegate

@optional

/**
 * This is triggered as soon as the SDK is ready, e.g. splash screen is finished.
 */
- (void) onSDKReady;

/** This function will be triggered, when an animation has ended
 * \param geometry the geometry which has finished animating
 * \param animationName the name of the just finished animation
 * \return void
 */
- (void) onAnimationEnd: (metaio::IGeometry*) geometry  andName:(NSString*) animationName;


/**
 * \brief This function will be triggered, if a movietexture-playback has ended
 * \param geometry the geometry which has finished animating/movie-playback
 * \param movieName the filename of the movie
 * \return void
 */
- (void) onMovieEnd: (metaio::IGeometry*) geometry  andName:(NSString*) movieName;

/**
 * \brief Request a callback that delivers the next camera image.
 *
 * The image will have the  dimensions of the current capture resolution.
 * To request this callback, call requestCameraFrame()
 *
 * \param cameraFrame the latest camera image
 * 
 * \note you must copy the ImageStuct::buffer, if you need it for later. 
 */
- (void) onNewCameraFrame: ( metaio::ImageStruct*)  cameraFrame;

/**
 * \brief Callback that notifies that camera image has been saved
 *
 * To request this callback, call requestCameraFrame(filepath, width, height)
 *
 * \param filepath File path in which image is written, or empty string in case of a failure
 * 
 */
- (void) onCameraImageSaved: (NSString*) filepath; 

/**
 * Callback that delivers screenshot as new ImageStruct.
 * The image struct buffer must be deleted by the application.
 * Note: This callback is called on the render thread.
 *
 * \param image Screenshot image
 */
-(void) onScreenshotImage:(metaio::ImageStruct*) image;

/**
 * Callback that notifies that screenshot has been saved to a file.
 * If the screenshot is not written to a file, the filepath will be
 * an empty string.
 * Note: This callback is called on the render thread.
 *
 * \param filepath File path where screenshot image has been written
 */
-(void) onScreenshot:(NSString*) filepath;

/**
 * \brief Callback that informs new pose states (tracked, detected or lost)
 *
 * This is called automatically as soon as poses have been updated. The vector
 * contains all the valid poses. 
 * The invalid pose is only returned for first frame as soon as target is lost 
 * to inform this event.
 * Note that this function is called in rendering thread, thus it would block
 * rendering. It should be returned as soon as possible wihout any expensive 
 * processing.
 * 
 * \param poses current valid poses
 * 
 */
- (void) onTrackingEvent: (std::vector<metaio::TrackingValues>) poses;

/**
 * \brief Callback that informs about instant 3D tracking event
 *
 * \param success result of the instant tracking event
 * \param file saved tracking configuration path
 *
 */
- (void) onInstantTrackingEvent: (bool)success file:(const std::string&) file;



@end


namespace metaio
{

	/** 
	 * \brief Specialized interface for iPhone.
	 * 
	 */
	class IMetaioSDKIOS : public virtual IMetaioSDK
	{
	public:
		
        virtual ~IMetaioSDKIOS() {};
        
        /**
         * Initialize the renderer
         *
         * \relates IMetaioSDKIOS
         * \param width width of the renderer
         * \param height height of the renderer
		 * \param screenRotation Screen rotation
         * \param renderSystem specify which renderer should be used
		 * \param eaglContext pointer to the openGL context (for fast texture upload)
         */
        virtual void initializeRenderer( int width, int height, ESCREEN_ROTATION screenRotation, 
			const ERENDER_SYSTEM renderSystem=ERENDER_SYSTEM_OPENGL_ES_2_0, void* eaglContext=0) = 0;
        
        /** \brief Register the delegate object that will receive callbacks
         * \param delegate the object
         * \return void
         */
        virtual void registerDelegate( NSObject<MetaioSDKDelegate>* delegate ) = 0;
        
        /**
		 * \brief Get a camera preview layer from the active camera session
		 *
		 * Use this to get a pointer to a AVCaptureVideoPreviewLayer that 
		 * is created based on the current camera session. You can use this 
		 * to draw the camera image in the background and add a transparent
		 * EAGLView on top of this. To prevent sdk from drawing the
		 * background in OpenGL you can activate the see-through mode.
		 *
		 * \code 	
		 *			[glView setBackgroundColor:[UIColor clearColor]];
		 *			m_metaioSDK->setSeeThrough(true);
		 *
		 *			AVCaptureVideoPreviewLayer* previewLayer = 
		 *					glView.m_metaioSDK->getCameraPreviewLayer();
		 *			previewLayer.frame = myUIView.bounds;
		 *			[myUIView.layer addSublayer:previewLayer];
		 * \endcode
		 *
		 * \sa Set sdk to see through mode using setSeeThrough ( 1 )
		 * \sa Start capturing using activateCamera ( index )
		 * \sa You can deactivate the capturing again with stopCamera()
		 *
		 * \note Only available on iOS >= 4.0. If you call this on 3.x nothing will happen.
		 * \note Not available on iPhone Simulator.
         * \return the pointer to the instance of the class AVCaptureVideoPreviewLayer
		 */
		virtual AVCaptureVideoPreviewLayer* getCameraPreviewLayer() = 0;    
        
        /**
         * @brief Specialized function for iPhone
         *
         * @param textureName name that should be assigned to the texture 
         *	(for reuse).
         * @param image image to set
         * @return pointer to geometry
         */
        virtual IGeometry* loadImageBillboard( const std::string& textureName, CGImageRef image ) = 0;
	
    };

    /** Provides access to raw image data of a CGImage.
     * This is e.g. needed when setting an MD2 texture from memory.
	 *
     * \code
     * ImageStruct imageContent;
     * CGContextRef context = nil;
     * 
     * beginGetDataForCGImage(image, &imageContent, &context);
     * 
     *  // use data
     *  // ....
     * endGetData(&context);
     *
     * \endcode
     *
     * \param image the source image
     * \param[out] imageContent after the call this will point to a struct containing the image content
     * \param[out] context after the call this will point to the created CGContext. This has to be deleted again by calling endGetData
     * 
     * \sa endGetData to delegate the context again
     */
     void beginGetDataForCGImage(CGImage* image, ImageStruct* imageContent, CGContextRef* context);
    
    
    /** Frees the image context that was created with beginGetDataForCGImage
     * \param context the context to free
     * 
     * \sa beginGetDataForCGImage to get data from a CGImage
     */
    void endGetData(CGContextRef* context);


	/**
	* \brief Create an ARMobileSystem instance
	*
	* \param signature The signature of the application identifier
	* \return a pointer to an ARMobileSystem instance
	*/
	IMetaioSDKIOS* CreateMetaioSDKIOS( const std::string& signature ); 


	/** Enumeration of iOS Devices
	 */
	enum E_IOS_DEVICETYPE
	{
		EID_IPHONEOLD,
		EID_IPHONE3GS,
		EID_IPHONE4,
		EID_IPHONE4S,
		EID_IPHONE5,
		EID_IPAD,
		EID_IPAD2,
		EID_IPAD3,
		EID_IPODOLD,
		EID_IPOD4,
		EID_IPOD5,
		EID_UNKNOWNIPHONE,
		EID_UNKNOWNIPAD,
		EID_UNKNOWNIPOD
	};
	
	/** Retrieve the current device type
	 * \return the device type of the current device. EID_UNKNOWN if its a new/unknown device
	 */
	E_IOS_DEVICETYPE getDeviceType();
	
	
	/** Convert a UIInterface orientation to a ESCREEN_ROTATION to use with the SDK
	 * \param interfaceOrientation item
	 * \return the corresponding ESCREEN_ROTATION
	 */
	ESCREEN_ROTATION getScreenRotationForInterfaceOrientation(NSInteger interfaceOrientation);

	
} //namespace metaio


#endif //___AS_IMETAIOSDKIOS_H_INCLUDED___
