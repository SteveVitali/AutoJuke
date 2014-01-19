//
//  PlaylistTableViewController.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playlist.h"
#import "CocoaLibSpotify.h"
#import "PlaylistPickerViewController.h"

@interface PlaylistTableViewController : UITableViewController <UIApplicationDelegate, SPSessionDelegate, SPSessionPlaybackDelegate, SPPlaybackManagerDelegate, SPLoginViewControllerDelegate, PlaylistPickerDelegate> {
   
    UIViewController *_mainViewController;
	UITextField *_trackURIField;
	UILabel *_trackTitle;
	UILabel *_trackArtist;
	UIImageView *_coverView;
	UISlider *_positionSlider;
	SPPlaybackManager *_playbackManager;
	SPTrack *_currentTrack;
}

@property Playlist *playlist;


@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UIViewController *mainViewController;

@property (nonatomic, strong) IBOutlet UITextField *trackURIField;
@property (nonatomic, strong) IBOutlet UILabel *trackTitle;
@property (nonatomic, strong) IBOutlet UILabel *trackArtist;
@property (nonatomic, strong) IBOutlet UIImageView *coverView;
@property (nonatomic, strong) IBOutlet UISlider *positionSlider;

@property (nonatomic, strong) SPTrack *currentTrack;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;

- (IBAction)setTrackPosition:(id)sender;
- (IBAction)setVolume:(id)sender;

@end
