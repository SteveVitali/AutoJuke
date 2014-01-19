//
//  Playlist.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CocoaLibSpotify.h"

@interface Playlist : NSObject

@property NSString *objectID;
@property NSString *name;
@property NSString *ownerName;
@property NSMutableArray *songs;
@property NSMutableArray *users;

// this contains each SPTrack's URL.absoluteString and name
@property NSMutableArray *songTitles;
@property NSMutableArray *songURIs;

@property PFObject *parsePlaylist;

- (id)initWithPFObject:(PFObject *)object;

- (NSMutableArray *) songURIs;
- (NSMutableArray *) songTitles;

- (void) addSPPlaylists:(NSArray *)playlists;
- (void) addSPTracks:(NSArray *)tracks;

@end
