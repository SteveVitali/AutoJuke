//
//  Playlist.m
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import "Playlist.h"

@implementation Playlist

- (id)init {
    self = [super init];
    if (self) {
        _songs = [[NSMutableArray alloc] init];
        _users = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
