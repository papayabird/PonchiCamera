//
//  PCAppDelegate.h
//  PonChiCamera
//
//  Created by papayabird on 2014/3/4.
//  Copyright (c) 2014年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (PCAppDelegate *)sharedAppDelegate;

@end
