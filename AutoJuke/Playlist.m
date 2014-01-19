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
        self.objectID = object.objectId;
    }
    return self;
}

- (NSMutableDictionary *)getSongsDictionary {
    
    NSMutableDictionary *playlistDict = [[NSMutableDictionary alloc] initWithObjects:self.songTitles forKeys:self.songURIs];
    
    return playlistDict;
}

@end
