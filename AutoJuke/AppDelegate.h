//
//  AppDelegate.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/17/14.
//  Copyright (c) 2014 Steve John Vitali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, SPSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end

