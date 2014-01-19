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

@implementation NowPlayingViewController {
    NSMutableArray *playbackHistory;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        playbackHistory = [[NSMutableDictionary alloc] init];
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

- (IBAction)playButtonPushed:(id)sender {
	
	// Invoked by clicking the "Play" button in the UI.
	if (_playbackManager.isPlaying)
    // there's a song playing
    {
        [self pauseTrack];
        [sender setImage:[UIImage imageNamed:@"glyphicons_174_pause.png"] forState:UIControlStateNormal];
    } else if (_currentTrack != nil)
    // there's nothing playing, but there is a track loaded up...
    {
        [self unpauseTrack];
        [sender setImage:[UIImage imageNamed:@"glyphicons_173_play.png"] forState:UIControlStateNormal];
    } else
    // there's nothing playing and there's not track loaded up.
    {
        [self moveToNextTrack];
        
        [sender setImage:[UIImage imageNamed:@"glyphicons_173_play.png"] forState:UIControlStateNormal];
    }
    //[sender ]
    
    return;
}

- (IBAction)nextButtonPushed:(id)sender {
    [self moveToNextTrack];
    [_toggleTrackPlayback setImage:[UIImage imageNamed:@"glyphicons_174_pause.png"] forState:UIControlStateNormal];
}

- (void)moveToNextTrack {
    if (_trackTitle != nil) {
        NSLog(@"okay");
        [playbackHistory addObject:_currentTrack];
    }
    
    NSURL *trackURL = [self.delegate getRandomTrackURI];
    
    [[SPSession sharedSession] trackForURL:trackURL callback:^(SPTrack *track) {
        if (track != nil) {
            [self playTrack:track];
        }
    }];
}

- (IBAction)previousButtonPushed:(id)sender {
    if (playbackHistory.count > 1) {
        [self moveToPreviousTrack];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This Is Awkward"
                                                        message:@"Nothing has played before this!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)moveToPreviousTrack {
    [playbackHistory removeLastObject];
    [self playTrack: [playbackHistory lastObject]];
}

- (void)playTrack:(SPTrack *)track {
            
    [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks)
    {
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
}

- (void)unpauseTrack {
    _playbackManager.isPlaying = YES;
}

- (void)pauseTrack {
    _playbackManager.isPlaying = NO;
}

- (IBAction)setTrackPosition:(id)sender {
    
	[self.playbackManager seekToTrackPosition: _elapsedTime.value];
}

- (void) setTrackPositionToValue:(NSTimeInterval)timeValue {
    
}

- (IBAction)setVolume:(id)sender {
    
	self.playbackManager.volume = [(UISlider *)sender value];
}

-(void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager {
    
    
}

@end
