//
//  CreatePlaylistViewController.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"

@interface CreatePlaylistViewController : UIViewController <SPSessionPlaybackDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;

- (IBAction)createPlaylist:(id)sender;

@end
