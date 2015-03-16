//
//  PCShotViewController.h
//  PonChiCamera
//
//  Created by papayabird on 2014/3/4.
//  Copyright (c) 2014年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PCShotViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

{
    IBOutlet UIImageView *imageView;
    AVCaptureSession *myCaptureSession;
    AVCaptureStillImageOutput *myStillImageOutput;
    AVCaptureVideoPreviewLayer *myPreviewLayer;
    __weak IBOutlet UIView *addView;
    
    AVCaptureDevicePosition deviceType;
}
@end
