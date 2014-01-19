//
//  PlaylistPickerItem.m
//  AutoJuke
//
//  Created by Steve John Vitali on 1/19/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import "PlaylistPickerItem.h"
#import "CocoaLibSpotify.h"

@implementation PlaylistPickerItem

- (id)initWithPlaylist:(SPPlaylist *)playlist {
    
    self = [super init];
    
    if (self) {
        
        self.playlist = playlist;
    }
    
    return self;
}

@end
