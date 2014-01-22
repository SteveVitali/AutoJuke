//
//  PlaylistPickerViewController.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistPickerItem.h"

@protocol PlaylistPickerDelegate;

@interface PlaylistPickerViewController : UITableViewController

@property NSMutableArray *playlistItems;
@property NSMutableArray *chosenPlaylists;
@property (weak) id<PlaylistPickerDelegate> delegate;

- (IBAction)didPressDone:(id)sender;

@end

@protocol PlaylistPickerDelegate <NSObject>

@required

- (void)addPlaylistsFromController:(PlaylistPickerViewController *)pickerController;

@end
