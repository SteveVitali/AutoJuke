//
//  NowPlayingViewController.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/19/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"

@interface NowPlayingViewController : UIViewController <SPSessionPlaybackDelegate> {
    UILabel *_trackTitle;
    UILabel *_trackArtist;
    UILabel *_trackAlbum;
    UIImageView *_trackAlbumCover;
    UISlider *_elapsedTime;
    UIButton *_previousTrack;
    UIButton *_nextTrack;
    UIButton *_toggleTrackPlayback;
}

@property (strong, nonatomic) IBOutlet UILabel *trackTitle;
@property (strong, nonatomic) IBOutlet UILabel *trackArtist;
@property (strong, nonatomic) IBOutlet UILabel *trackAlbum;
@property (strong, nonatomic) IBOutlet UIImageView *trackAlbumCover;
@property (strong, nonatomic) IBOutlet UISlider *elapsedTime;
@property (strong, nonatomic) IBOutlet UIButton *previousTrack;
@property (strong, nonatomic) IBOutlet UIButton *nextTrack;
@property (strong, nonatomic) IBOutlet UIButton *toggleTrackPlayback;

@end
