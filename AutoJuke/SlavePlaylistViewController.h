//
//  SlavePlaylistViewController.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playlist.h"
#import "PlaylistPickerViewController.h"

@interface SlavePlaylistViewController : UITableViewController <PlaylistPickerDelegate>

@property Playlist *playlist;

- (void)addPlaylistsFromController:(PlaylistPickerViewController *)pickerController;

@end
