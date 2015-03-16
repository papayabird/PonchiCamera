//
//  PCShotViewController.m
//  PonChiCamera
//
//  Created by papayabird on 2014/3/4.
//  Copyright (c) 2014年 papayabird. All rights reserved.
//

#import "PCShotViewController.h"
#import "PCEditPhotoViewController.h"

@interface PCShotViewController ()

@end

@implementation PCShotViewController

- (id)init
{
    self = [super initWithNibName:@"PCShotViewController" bundle:nil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    deviceType = AVCaptureDevicePositionBack;
    [self openCamera];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)openCamera
{
    //建立 AVCaptureSession
    myCaptureSession = [[AVCaptureSession alloc] init];
    [myCaptureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    //建立 AVCaptureDeviceInput
    NSArray *myDevices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in myDevices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            NSLog(@"後攝影機硬體名稱: %@", [device localizedName]);
        }
        
        if ([device position] == AVCaptureDevicePositionFront) {
            NSLog(@"前攝影機硬體名稱: %@", [device localizedName]);
        }
        
        if ([device hasMediaType:AVMediaTypeAudio]) {
            NSLog(@"麥克風硬體名稱: %@", [device localizedName]);
        }
    }
    
    //使用後置鏡頭當做輸入
    NSError *error = nil;
    for (AVCaptureDevice *device in myDevices) {
        if ([device position] == deviceType) {
            
            AVCaptureDeviceInput *myDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            
            if (error) {
                //裝置取得失敗時的處理常式
            } else {
                [myCaptureSession addInput:myDeviceInput];
            }
        }
    }
    
    //建立 AVCaptureVideoPreviewLayer
    myPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:myCaptureSession];
    [myPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    CGRect bounds = imageView.layer.bounds;
    myPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    myPreviewLayer.bounds=bounds;
    myPreviewLayer.position=CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    [addView.layer addSublayer:myPreviewLayer];
    
    
    /* 直接設定大小
    CGRect rect = CGRectMake(160, 180, 320, 240);
    [myPreviewLayer setBounds:rect];
    
    UIView *myView = [[UIView alloc]initWithFrame:rect];
    [myView.layer addSublayer:myPreviewLayer];
     [self.view addSubview:myView];
    */
    
    //啟用攝影機
    [myCaptureSession startRunning];
    
    
    //建立 AVCaptureStillImageOutput
    myStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *myOutputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [myStillImageOutput setOutputSettings:myOutputSettings];
    
    [myCaptureSession addOutput:myStillImageOutput];
}

- (IBAction)shotAction:(id)sender
{
    AVCaptureConnection *myVideoConnection = nil;
    
    //從 AVCaptureStillImageOutput 中取得正確類型的 AVCaptureConnection
    for (AVCaptureConnection *connection in myStillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                
                myVideoConnection = connection;
                break;
            }
        }
    }
    
    //擷取影像（包含拍照音效）
    [myStillImageOutput captureStillImageAsynchronouslyFromConnection:myVideoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        //完成擷取時的處理常式(Block)
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            //取得的靜態影像
            UIImage *myImage = [[UIImage alloc] initWithData:imageData];
            [imageView setImage:myImage];
            
            addView.hidden = YES;
            /*
            //取得影像資料（需要ImageIO.framework 與 CoreMedia.framework）
            CFDictionaryRef myAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
            NSLog(@"影像屬性: %@", myAttachments);
             */
            
        }
    }];
}

- (IBAction)resetShotAction:(id)sender
{
    addView.hidden = NO;
    imageView.image = nil;
//    NSLog(@"123");
}

- (IBAction)changeCameraAction:(id)sender
{
    if (deviceType == AVCaptureDevicePositionBack) {
        deviceType = AVCaptureDevicePositionFront;
    }
    else {
        deviceType = AVCaptureDevicePositionBack;
    }
    [self openCamera];
}


- (IBAction)selectAgainAction:(id)sender
{
    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)editAction:(id)sender
{
    PCEditPhotoViewController *editVC = [[PCEditPhotoViewController alloc] initWitImage:imageView.image];
    [self.navigationController pushViewController:editVC animated:YES];
}


-(void) showImagePicker : (UIImagePickerControllerSourceType) sourceType
{
#if TARGET_IPHONE_SIMULATOR
    
#else
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.sourceType = sourceType;  //從帶進來的參數作判斷
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    [[[[PCAppDelegate sharedAppDelegate] window] rootViewController] presentViewController:imagePicker animated:YES completion:nil];
    
#endif
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chooseImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    chooseImage = [self maskImage:chooseImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        PCEditPhotoViewController *editVC = [[PCEditPhotoViewController alloc] initWitImage:chooseImage];
        [self.navigationController pushViewController:editVC animated:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker //取消選取相片
{
    //    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
- (UIImage*)maskImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [[UIImage imageNamed:@"msk.png"] drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGImageRef maskRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    if ((CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone)
        || (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipFirst)
        || (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipLast)) {
        imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
    }
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    
    return retImage;
}

CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage) {
    CGImageRef retVal = NULL;
    
    size_t width = CGImageGetWidth(sourceImage);
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    
    if (offscreenContext != NULL) {
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        CGContextRelease(offscreenContext);
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return retVal;
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
