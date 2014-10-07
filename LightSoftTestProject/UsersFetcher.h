//
//  UsersFetcher.h
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 07/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal, OCTEntity;

@interface UsersFetcher : NSObject

@property (nonatomic, readonly) BOOL fetching;

- (RACSignal*)next;

+ (RACSignal*)fetchUserReposWithUser:(OCTEntity*)entity;

+ (RACSignal*)fetchUsersWithQuery:(NSString*)q;

@end
