//
//  PlaylistTableViewController.m
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import "PlaylistTableViewController.h"
#import "CocoaLibSpotify.h"
#import <Parse/Parse.h>

#define SP_LIBSPOTIFY_DEBUG_LOGGING 1

@interface PlaylistTableViewController ()

@end

@implementation PlaylistTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Override point for customization after application launch.
	
    // not sure the line below is necessary
    //[self.window makeKeyAndVisible];
    
    self.navigationItem.title = self.playlist.name;
    
	[self addObserver:self forKeyPath:@"currentTrack.name" options:0 context:nil];
	[self addObserver:self forKeyPath:@"currentTrack.artists" options:0 context:nil];
	[self addObserver:self forKeyPath:@"currentTrack.duration" options:0 context:nil];
	[self addObserver:self forKeyPath:@"currentTrack.album.cover.image" options:0 context:nil];
	[self addObserver:self forKeyPath:@"playbackManager.trackPosition" options:0 context:nil];
	    
    [self.tableView reloadData];
}

-(void)showLogin {
    
	SPLoginViewController *spotifyLogin = [SPLoginViewController
                                           loginControllerForSession:[SPSession sharedSession]];
	spotifyLogin.allowsCancel = YES;
	// ^ To allow the user to cancel (i.e., your application doesn't require a logged-in Spotify user, set this to YES.
	[self presentViewController:spotifyLogin animated:NO completion:nil];
}

- (IBAction)setTrackPosition:(id)sender {
    
	[self.playbackManager seekToTrackPosition:self.positionSlider.value];
}

- (IBAction)setVolume:(id)sender {
    
	self.playbackManager.volume = [(UISlider *)sender value];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"currentTrack.name"]) {
        self.trackTitle.text = self.currentTrack.name;
	} else if ([keyPath isEqualToString:@"currentTrack.artists"]) {
		self.trackArtist.text = [[self.currentTrack.artists valueForKey:@"name"] componentsJoinedByString:@","];
	} else if ([keyPath isEqualToString:@"currentTrack.album.cover.image"]) {
		self.coverView.image = self.currentTrack.album.cover.image;
	} else if ([keyPath isEqualToString:@"currentTrack.duration"]) {
		self.positionSlider.maximumValue = self.currentTrack.duration;
	} else if ([keyPath isEqualToString:@"playbackManager.trackPosition"]) {
		// Only update the slider if the user isn't currently dragging it.
		if (!self.positionSlider.highlighted)
			self.positionSlider.value = self.playbackManager.trackPosition;
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
	
	[self removeObserver:self forKeyPath:@"currentTrack.name"];
	[self removeObserver:self forKeyPath:@"currentTrack.artists"];
	[self removeObserver:self forKeyPath:@"currentTrack.album.cover.image"];
	[self removeObserver:self forKeyPath:@"playbackManager.trackPosition"];
	
}

#pragma mark SPSessionDelegate Methods

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession {
	// Called after a successful login.
    
	[SPAsyncLoading waitUntilLoaded:aSession timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
		[SPAsyncLoading waitUntilLoaded:aSession.user timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Hello %@!", aSession.user.displayName]
															message:@"Something, something AutoJuke."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
		}];
	}];
}

-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error {
	// Called after a failed login. SPLoginViewController will deal with this for us.
}

-(void)sessionDidLogOut:(SPSession *)aSession; {
	// Called after a logout has been completed.
}

-(void)session:(SPSession *)aSession didGenerateLoginCredentials:(NSString *)credential forUserName:(NSString *)userName {
    
	// Called when login credentials are created. If you want to save user logins, uncomment the code below.
    
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *storedCredentials = [[defaults valueForKey:@"SpotifyUsers"] mutableCopy];
    
    if (storedCredentials == nil)
        storedCredentials = [NSMutableDictionary dictionary];
    
    [storedCredentials setValue:credential forKey:userName];
    [defaults setValue:storedCredentials forKey:@"SpotifyUsers"];
    
}

-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error; {
	if (SP_LIBSPOTIFY_DEBUG_LOGGING != 0)
		NSLog(@"CocoaLS NETWORK ERROR: %@", error);
}

-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage; {
	if (SP_LIBSPOTIFY_DEBUG_LOGGING != 0)
		NSLog(@"CocoaLS DEBUG: %@", aMessage);
}

-(void)sessionDidChangeMetadata:(SPSession *)aSession; {
	// Called when metadata has been updated somewhere in the
	// CocoaLibSpotify object model. You don't normally need to do
	// anything here. KVO on the metadata you're interested in instead.
}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
	// Called when the Spotify service wants to relay a piece of information to the user.
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aMessage
													message:@"This message was sent to you from the Spotify service."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SPLoginViewController Delegate

-(void)loginViewController:(SPLoginViewController *)controller didCompleteSuccessfully:(BOOL)didLogin {
	
	//[self dismissModalViewControllerAnimated:YES];
	
	//if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CreatePlaylist"])
	//	self.playlist = [[[SPSession sharedSession] userPlaylists] createPlaylistWithName:self.playlistNameField.stringValue];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"numberOfRowsInSection");
    return [self.playlist.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[self.playlist.songs objectAtIndex:indexPath.row] name];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark Finding Tracks

- (void)addPlaylistToDatabase {
    
    self.playlist.parsePlaylist = [PFObject objectWithClassName:@"Playlist"];
    
    self.playlist.parsePlaylist[@"songURIs"] = self.playlist.songURIs;
    self.playlist.parsePlaylist[@"songTitles"] = self.playlist.songTitles;
    self.playlist.parsePlaylist[@"owner"] = [[SPSession sharedSession] user].canonicalName;
    self.playlist.parsePlaylist[@"name"]  = self.playlist.name;
    
    [self.playlist.parsePlaylist save];
}

-(NSArray *)playlistsInFolder:(SPPlaylistFolder *)aFolder {
	
	NSMutableArray *playlists = [NSMutableArray arrayWithCapacity:[[aFolder playlists] count]];
	
	for (id playlistOrFolder in aFolder.playlists) {
		if ([playlistOrFolder isKindOfClass:[SPPlaylist class]]) {
			[playlists addObject:playlistOrFolder];
		} else {
			[playlists addObjectsFromArray:[self playlistsInFolder:playlistOrFolder]];
		}
	}
	return [NSArray arrayWithArray:playlists];
}

-(NSArray *)tracksFromPlaylistItems:(NSArray *)items {
	
	NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:items.count];
	
	for (SPPlaylistItem *anItem in items) {
		if (anItem.itemClass == [SPTrack class]) {
			[tracks addObject:anItem.item];
		}
	}
	
	return [NSArray arrayWithArray:tracks];
}

#pragma mark Playback

- (void)startPlaybackOfTrack:(SPTrack *)aTrack {
	
	[SPAsyncLoading waitUntilLoaded:aTrack timeout:5.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
		[self.playbackManager playTrack:aTrack callback:^(NSError *error) {
			
			if (!error) return;
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Play"
															message:error.localizedDescription
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
		}];
	}];
}

-(void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager {
    
    
}

#pragma mark - PlaylistPickerDelegate

- (void)addPlaylistsFromController:(PlaylistPickerViewController *)pickerController {
    
    NSMutableArray *playlists = [[NSMutableArray alloc] initWithArray:pickerController.chosenPlaylists];
    
    NSLog(@"these are the playlists chosen: %@",playlists);
    
    [SPAsyncLoading waitUntilLoaded:playlists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylists, NSArray *notLoadedPlaylists) {
        
        // All of our playlists have loaded their metadata — wait for all tracks to load their metadata.
        NSArray *playlistItems = [playlists valueForKeyPath:@"@unionOfArrays.items"];
        NSArray *tracks = [self tracksFromPlaylistItems:playlistItems];
        
        [SPAsyncLoading waitUntilLoaded:tracks timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedTracks, NSArray *notLoadedTracks) {
            
            // All of our tracks have loaded their metadata. Hooray!
            NSMutableArray *theTrackPool = [NSMutableArray arrayWithCapacity:loadedTracks.count];
            
            for (SPTrack *aTrack in loadedTracks) {
                if (aTrack.availability == SP_TRACK_AVAILABILITY_AVAILABLE && [aTrack.name length] > 0)
                    [theTrackPool addObject:aTrack];
            }
            NSLog(@"the track pool: %@", theTrackPool);
            
            self.playlist.songs = [NSMutableArray arrayWithArray:[[NSSet setWithArray:theTrackPool] allObjects]];
            // ^ Thin out duplicates.
            
            //[self startNewRound];
            NSLog(@"there are %d items in the tracks list",self.playlist.songs.count);
            for(int i=0; i<[self.playlist.songs count]; i++) {
                
                SPTrack *test = [self.playlist.songs objectAtIndex:i];
                if (test.isLocal) {
                    [self.playlist.songs removeObjectAtIndex:i];
                }
            }
            NSLog(@"your user name is %@",[[SPSession sharedSession] user].canonicalName);
            
            [self.tableView reloadData];
            
            self.playlist.songTitles = [[NSMutableArray alloc] init];
            self.playlist.songURIs  = [[NSMutableArray alloc] init];
            
            for(int i=0; i<self.playlist.songs.count; i++) {
                
                SPTrack *track = [self.playlist.songs objectAtIndex:i];
                [self.playlist.songTitles addObject:track.name];
                [self.playlist.songURIs addObject:track.spotifyURL.absoluteString];
            }
            [self addPlaylistToDatabase];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                            message:@"Albums have been added!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        }];
    }];
    
}
/*
-(void)waitAndFillTrackPool {
	
	[SPAsyncLoading waitUntilLoaded:[SPSession sharedSession] timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedession, NSArray *notLoadedSession) {
		
		// The session is logged in and loaded — now wait for the userPlaylists to load.
		NSLog(@"[%@ %@]: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), @"Session loaded.");
		
		[SPAsyncLoading waitUntilLoaded:[SPSession sharedSession].userPlaylists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedContainers, NSArray *notLoadedContainers) {
			
			// User playlists are loaded — wait for playlists to load their metadata.
			NSLog(@"[%@ %@]: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), @"Container loaded.");
			
			NSMutableArray *playlists = [NSMutableArray array];
			[playlists addObject:[SPSession sharedSession].starredPlaylist];
			[playlists addObject:[SPSession sharedSession].inboxPlaylist];
			[playlists addObjectsFromArray:[SPSession sharedSession].userPlaylists.flattenedPlaylists];
			
			[SPAsyncLoading waitUntilLoaded:playlists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylists, NSArray *notLoadedPlaylists) {
				
				// All of our playlists have loaded their metadata — wait for all tracks to load their metadata.
				NSLog(@"[%@ %@]: %@ of %@ playlists loaded.", NSStringFromClass([self class]), NSStringFromSelector(_cmd),
					  [NSNumber numberWithInteger:loadedPlaylists.count], [NSNumber numberWithInteger:loadedPlaylists.count + notLoadedPlaylists.count]);
				
				NSArray *playlistItems = [loadedPlaylists valueForKeyPath:@"@unionOfArrays.items"];
				NSArray *tracks = [self tracksFromPlaylistItems:playlistItems];
				
				[SPAsyncLoading waitUntilLoaded:tracks timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedTracks, NSArray *notLoadedTracks) {
					
					// All of our tracks have loaded their metadata. Hooray!
					NSLog(@"[%@ %@]: %@ of %@ tracks loaded.", NSStringFromClass([self class]), NSStringFromSelector(_cmd),
						  [NSNumber numberWithInteger:loadedTracks.count], [NSNumber numberWithInteger:loadedTracks.count + notLoadedTracks.count]);
					
					NSMutableArray *theTrackPool = [NSMutableArray arrayWithCapacity:loadedTracks.count];
					
					for (SPTrack *aTrack in loadedTracks) {
						if (aTrack.availability == SP_TRACK_AVAILABILITY_AVAILABLE && [aTrack.name length] > 0)
							[theTrackPool addObject:aTrack];
					}
					
                    self.playlist.songs = [NSMutableArray arrayWithArray:[[NSSet setWithArray:theTrackPool] allObjects]];
					// ^ Thin out duplicates.
					
					//[self startNewRound];
                    NSLog(@"there are %d items in the tracks list",self.playlist.songs.count);
                    for(int i=0; i<[self.playlist.songs count]; i++) {
                        
                        SPTrack *test = [self.playlist.songs objectAtIndex:i];
                        if (test.isLocal) {
                            [self.playlist.songs removeObjectAtIndex:i];
                        }
                    }
                    NSLog(@"your user name is %@",[[SPSession sharedSession] user].canonicalName);
                    
                    [self.tableView reloadData];
                    
                    self.playlist.songTitles = [[NSMutableArray alloc] init];
                    self.playlist.songURIs  = [[NSMutableArray alloc] init];
                    
                    for(int i=0; i<self.playlist.songs.count; i++) {
                        
                        SPTrack *track = [self.playlist.songs objectAtIndex:i];
                        [self.playlist.songTitles addObject:track.name];
                        [self.playlist.songURIs addObject:track.spotifyURL.absoluteString];
                    }
                    [self addPlaylistToDatabase];
                    NSLog(@"what is thiasdfasdfs help %@",[[SPSession sharedSession] userPlaylists].playlists);
                    
				}];
			}];
		}];
	}];
}
 */

@end

