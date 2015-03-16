//
//  PCEditPhotoViewController.m
//  PonChiCamera
//
//  Created by papayabird on 2014/3/4.
//  Copyright (c) 2014年 papayabird. All rights reserved.
//

#import "PCEditPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PCEditPhotoViewController ()

@end

@implementation PCEditPhotoViewController

- (id)initWitImage:(UIImage *)image
{
    self = [super initWithNibName:@"PCEditPhotoViewController" bundle:nil];
    if (self) {
        
        photo = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    displayImageView.image = photo;
}

- (UIImage *) captureScreen {
    UIGraphicsBeginImageContextWithOptions(displayImageView.bounds.size, NO, 2.0);
    [displayImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveAction:(id)sender
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    [library writeImageToSavedPhotosAlbum:[[self captureScreen] CGImage] orientation:(ALAssetOrientation)[[self captureScreen] imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error)
     {
         
         UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"儲存成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [successAlert show];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
