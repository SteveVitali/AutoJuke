//
//  AppDelegate.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/17/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIViewController *viewController;
@property (nonatomic, strong) IBOutlet UIWindow *window;

@end

