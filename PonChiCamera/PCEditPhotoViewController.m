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

{

}

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
    
    NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"%@", filters);
    [filters count];
    NSLog(@"一共有 %li 種 CIFilter 濾鏡效果", [filters count]);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    displayImageView.image = photo;
}

-(UIImage *)filterWithImage:(UIImage *)image index:(NSInteger)index
{
    // 創建基於 GPU 的 CIContext 對象
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciSourceImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter;
    switch (index) {
        case 0:
            
            break;
        case 1:
            filter = [CIFilter filterWithName:@"CIColorControls"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            [filter setValue:@(1.1) forKey:kCIInputSaturationKey];
            [filter setValue:@(1.1) forKey:kCIInputContrastKey];
            [filter setValue:@(0.0) forKey:kCIInputBrightnessKey];
            break;
        case 2:
            filter = [CIFilter filterWithName:@"CIHueAdjust"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            [filter setValue:@(0.5) forKey:kCIInputAngleKey];
            break;
        case 3:
            filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 4:
            filter = [CIFilter filterWithName:@"CIGammaAdjust"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            [filter setValue:@(0.75) forKey:@"inputPower"];
            break;
        case 5:
            filter = [CIFilter filterWithName:@"CILinearToSRGBToneCurve"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 6:
            filter = [CIFilter filterWithName:@"CISRGBToneCurveToLinear"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 7:
            filter = [CIFilter filterWithName:@"CIVibrance"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            [filter setValue:@(2.5) forKey:@"inputAmount"];
            break;
        case 8:
            filter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 9:
            filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 10:
            filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 11:
            filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 12:
            filter = [CIFilter filterWithName:@"CIVignette"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            [filter setValue:@(1.9) forKey:kCIInputRadiusKey];
            [filter setValue:@(1.4) forKey:kCIInputIntensityKey];
            break;
        default:
            break;
    }
    
    // 得到過濾後的圖片
    CIImage *outputImage = [filter outputImage];
    
    // 轉換圖片
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    
    // 釋放 C 對象
    CGImageRelease(cgImage);
    
    return newImage;
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
