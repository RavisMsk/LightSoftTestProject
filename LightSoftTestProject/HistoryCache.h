//
//  HistoryCache.h
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 07/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCTEntity;

@interface HistoryCache : NSObject

+ (void)checkCacheExistance;
+ (void)pushToHistoryWithEntity:(OCTEntity*)entity
                     reposCount:(NSUInteger)repos;

+ (NSArray*)history;

@end
