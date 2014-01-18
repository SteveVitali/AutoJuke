//
//  Playlist.h
//  AutoJuke
//
//  Created by Steve John Vitali on 1/18/14.
//  Copyright (c) 2014 Point One. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Playlist : NSObject

@property NSString *name;
@property NSString *ownerName;
@property NSMutableArray *songs;
@property NSMutableArray *users;

@property PFObject *parsePlaylist;

@end
