//
//  PlaylistPickerItem.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/19/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLibSpotify.h"

@interface PlaylistPickerItem : NSObject

@property BOOL completed;
@property SPPlaylist *playlist;

- (id)initWithPlaylist:(SPPlaylist *)playlist;

@end
