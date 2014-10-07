//
//  HistoryCache.m
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 07/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import "HistoryCache.h"

#import <OctoKit.h>

#define HIST_PATH [(NSString*)NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"history"]

@implementation HistoryCache

+ (void)checkCacheExistance{;
    if (![[NSFileManager defaultManager] fileExistsAtPath:HIST_PATH]){
        NSLog(@"Creating cache file.");
        if (![NSKeyedArchiver archiveRootObject:@[]
                                         toFile:HIST_PATH]){
            NSLog(@"Couldnt archive.");
        }
    }
}

+ (void)pushToHistoryWithEntity:(OCTEntity *)entity
                     reposCount:(NSUInteger)repos{
    NSMutableArray *history = [[self history] mutableCopy];
    if ([history containsObject:entity])
        [history removeObject:entity];
    [history insertObject:entity
                  atIndex:0];
    if (history.count > 5)
        [history removeLastObject];
    if (![NSKeyedArchiver archiveRootObject:history
                                     toFile:HIST_PATH])
        NSLog(@"Error re-archiving cache.");
}

+ (NSArray *)history{
    return (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithFile:HIST_PATH];
}

@end
