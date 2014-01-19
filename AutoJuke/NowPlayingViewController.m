//
//  NowPlayingViewController.m
//  AutoJuke
//
//  Created by Steve John Vitali on 1/19/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import "NowPlayingViewController.h"

@interface NowPlayingViewController ()

@end

@implementation NowPlayingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /****************************
     ** Playback Manager Jaunt **
     ****************************/
    
    _playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    
    // observe current[...] variables and if changed change IBOutlets accordingly
    // see below -(void) observeValueForKeyPath:ofObject:change:context:
    [self addObserver:self forKeyPath:@"currentTrack.name" options:0 context:nil];
    [self addObserver:self forKeyPath:@"currentTrack.artists" options:0 context:nil];
    [self addObserver:self forKeyPath:@"currentTrack.album.name" options:0 context:nil];
    [self addObserver:self forKeyPath:@"currentTrack.duration" options:0 context:nil];
    [self addObserver:self forKeyPath:@"currentTrack.album.cover.image" options:0 context:nil];
    [self addObserver:self forKeyPath:@"playbackManager.trackPosition" options:0 context:nil];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqualToString:@"currentTrack.name"]) {
        self.trackTitle.text = self.currentTrack.name;
	} else if ([keyPath isEqualToString:@"currentTrack.artists"]) {
		self.trackArtist.text = [[self.currentTrack.artists valueForKey:@"name"] componentsJoinedByString:@","];
    } else if ([keyPath isEqualToString:@"currentTrack.album.name"]) {
        self.trackAlbum.text = self.currentTrack.album.name;
    } else if ([keyPath isEqualToString:@"currentTrack.album.cover.image"]) {
		self.trackAlbumCover.image = self.currentTrack.album.cover.image;
	} else if ([keyPath isEqualToString:@"currentTrack.duration"]) {
		self.elapsedTime.maximumValue = self.currentTrack.duration;
	} else if ([keyPath isEqualToString:@"playbackManager.trackPosition"]) {
		// Only update the slider if the user isn't currently dragging it.
		if (!self.elapsedTime.highlighted)
			self.elapsedTime.value = self.playbackManager.trackPosition;
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Playback

- (IBAction)playTrack:(id)sender {
	
	// Invoked by clicking the "Play" button in the UI.
	
	NSURL *trackURL = [self.delegate getRandomTrackURI];
    NSLog(@"URL: %@",trackURL);
    
    [[SPSession sharedSession] trackForURL:trackURL callback:^(SPTrack *track) {
        
        if (track != nil) {
            
            [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
                [self.playbackManager playTrack:track callback:^(NSError *error) {
                    
                    if (error != nil) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Play Track"
                                                                        message:[error localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    } else {
                        self.currentTrack = track;
                    }
                    
                }];
            }];
        } else NSLog(@"it is nil");
    }];
    
    return;
}

- (IBAction)setTrackPosition:(id)sender {
    
	[self.playbackManager seekToTrackPosition:self.elapsedTime.value];
}

- (IBAction)setVolume:(id)sender {
    
	self.playbackManager.volume = [(UISlider *)sender value];
}

-(void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager {
    
    
}

@end
