//
//  JoinPlaylistViewController.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinPlaylistViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;

- (IBAction)joinPlaylist:(id)sender;

@end
