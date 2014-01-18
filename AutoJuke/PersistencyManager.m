//
//  PersistencyManager.m
//  AutoFlip
//
//  Created by Steve John Vitali on 12/30/13.
//  Copyright (c) 2013 Steve John Vitali. All rights reserved.
//

#import "PersistencyManager.h"

@interface PersistencyManager() {

}
@end

@implementation PersistencyManager

- (id)init {
    
    self = [super init];
    if (self) {
        
        //NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory()
        //                      stringByAppendingString:@"/Documents/something.bin"]];
        //self.somethings = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return self;
}

@end
