//
//  InfoService.h
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 07/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ErrorCode) {
    ErrAlreadyFetching = 0,
    ErrUnknown,
};

@interface InfoService : NSObject

+ (NSString*)errorDomain;
+ (NSString*)developer;
+ (NSString*)version;

@end
