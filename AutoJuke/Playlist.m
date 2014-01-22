//
//  Playlist.m
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import "Playlist.h"
#import <Parse/Parse.h>
#import "SPTrack.h"

@implementation Playlist

- (id)init {
    self = [super init];
    if (self) {
        _songs = [[NSMutableArray alloc] init];
        _users = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithPFObject:(PFObject *)object {
    
    self = [super init];
    if (self) {
        self.objectID   = object.objectId;
        self.name       = object[@"name"];
        self.songTitles = object[@"songTitles"];
        self.songURIs   = object[@"songURIs"];
    }
    return self;
}

- (NSMutableArray *) getSongURIs {
    if (_songs.count > 0) {
        NSMutableArray *songURIs = [[NSMutableArray alloc] init];
        
        for (SPTrack *song in _songs) {
            [songURIs addObject:song.spotifyURL.absoluteString];
        }
        
        return songURIs;
    } else {
        return nil;
    }
}

- (NSMutableArray *) getSongNames {
    if (_songs.count > 0) {
        NSMutableArray *songNames = [[NSMutableArray alloc] init];
        
        for (SPTrack *song in _songs) {
            [songNames addObject:song.name];
        }
        
        return songNames;
    } else {
        return nil;
    }
}

- (void) addSPPlaylists:(NSArray *)playlists {
    [SPAsyncLoading waitUntilLoaded:playlists timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedPlaylists, NSArray *notLoadedPlaylists) {
        
        // All of our playlists have loaded their metadata — wait for all tracks to load their metadata.
        NSArray *playlistItems = [playlists valueForKeyPath:@"@unionOfArrays.items"];
        NSArray *tracks = [self tracksFromPlaylistItems:playlistItems];
        
        [self addSPTracks:tracks];
        
    }];
}

- (void) addSPTracks:(NSArray *)tracks {
    [SPAsyncLoading waitUntilLoaded:tracks timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedTracks, NSArray *notLoadedTracks) {
        
        // All of our tracks have loaded their metadata. Hooray!
        NSMutableArray *theTrackPool = [NSMutableArray arrayWithCapacity:loadedTracks.count];
        
        for (SPTrack *aTrack in loadedTracks) {
            if (aTrack.availability == SP_TRACK_AVAILABILITY_AVAILABLE && [aTrack.name length] > 0)
                [theTrackPool addObject:aTrack];
        }
        
        NSMutableArray *tempSongs = [NSMutableArray arrayWithArray:[[NSSet setWithArray:theTrackPool] allObjects]];
        
        // [self addPlaylistsToParseDatabase:tempSongs];
        // [self.tableView reloadData];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"Albums have been added!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)addPlaylistsToParseDatabase:(NSMutableArray *)tempSongs {
    
    NSMutableArray *tempTitles= [[NSMutableArray alloc] init];
    NSMutableArray *tempURIs  = [[NSMutableArray alloc] init];
    
    for(int i=0; i<tempSongs.count; i++) {
        
        SPTrack *track = [tempSongs objectAtIndex:i];
        [tempTitles addObject:track.name];
        [tempURIs addObject:track.spotifyURL.absoluteString];
    }
    
    for(int i=0; i<[tempSongs count]; i++) {
        
        SPTrack *test = [tempSongs objectAtIndex:i];
        if (test.isLocal) {
            [tempSongs removeObjectAtIndex:i];
        }
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Playlist"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:_objectID block:^(PFObject *playlist, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        [playlist addUniqueObjectsFromArray:tempTitles forKey:@"songTitles"];
        [playlist addUniqueObjectsFromArray:tempURIs forKey:@"songURIs"];
        
        [playlist saveInBackground];
        
    }];
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

@end
