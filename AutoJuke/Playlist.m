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
        self.name = object[@"name"];
        
    }
    return self;
}

- (NSMutableDictionary *)getSongsDictionary {
    
    NSMutableArray *songNames = [[NSMutableArray alloc] init];
    NSMutableArray *songURIs  = [[NSMutableArray alloc] init];
    
    for(int i=0; i<self.songs.count; i++) {
        
        SPTrack *track = [self.songs objectAtIndex:i];
        [songNames addObject:track.name];
        [songURIs addObject:track.spotifyURL.absoluteString];
    }
    NSMutableDictionary *playlistDict = [[NSMutableDictionary alloc] initWithObjects:songNames forKeys:songURIs];
    
    return playlistDict;
}


@end
