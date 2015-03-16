//
//  PCEditPhotoViewController.h
//  PonChiCamera
//
//  Created by papayabird on 2014/3/4.
//  Copyright (c) 2014年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCEditPhotoViewController : UIViewController

{
    UIImage *photo;
    IBOutlet UIScrollView *imageScrollView;
    __weak IBOutlet UIImageView *displayImageView;
}

- (id)initWitImage:(UIImage *)image;


@end
