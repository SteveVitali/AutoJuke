//
//  ViewController.h
//  AutoJuke
//
//  Created by Sam Moore on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"

@interface ViewController : UIViewController

- (IBAction)didPressHostButton:(id)sender;
- (IBAction)didPressJoinButton:(id)sender;

@property (weak, nonatomic) IBOutlet FUIButton *hostButton;
@property (weak, nonatomic) IBOutlet FUIButton *joinButton;


@end
