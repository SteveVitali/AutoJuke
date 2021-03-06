//
//  Library.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//
//
//ABOUT THIS CLASS:
//It's mostly utility methods for things
//It uses the "Facade" design pattern to encapsulate
//the functionality of PersistencyManager/etc. but from
//the outside it looks like it's all coming from LibraryAPI

#import "LibraryAPI.h"
#import "PersistencyManager.h"

@interface LibraryAPI() {
    
    PersistencyManager *persistencyManager;
    
}
@end

@implementation LibraryAPI

- (id)init {
    
    self = [super init];
    if (self) {

    }
    return self;
}

+ (LibraryAPI *)sharedInstance {
    
    static LibraryAPI *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    return _sharedInstance;
}

@end
