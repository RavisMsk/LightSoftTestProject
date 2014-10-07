//
//  UsersFetcher.m
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 07/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import "UsersFetcher.h"

#import <OctoKit.h>

#import "InfoService.h"
#import "NSString+Betweener.h"

@interface UsersFetcher ()

@property (nonatomic, assign) NSUInteger since;
@property (nonatomic, strong) OCTClient *client;
@property (nonatomic, readwrite) BOOL fetching;

@end

@implementation UsersFetcher

+ (RACSignal *)fetchUserReposWithUser:(OCTEntity *)entity{
    OCTUser *user = [OCTUser userWithRawLogin:entity.login
                                       server:entity.server];
    OCTClient *client = [OCTClient unauthenticatedClientWithUser:user];
    return [client fetchUserRepositories];
}

+ (RACSignal *)fetchUsersWithQuery:(NSString *)q{
    OCTClient *client = [[OCTClient alloc] initWithServer:[OCTServer dotComServer]];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET"
                                                    path:@"/search/users"
                                              parameters:@{@"q":q}];
    return [client enqueueRequest:req
                      resultClass:[OCTEntity class]
                    fetchAllPages:NO];
}

- (instancetype)init{
    self = [super init];
    if (self){
        self.since = 0;
        self.fetching = NO;
        self.client = [[OCTClient alloc] initWithServer:[OCTServer dotComServer]];
    }
    return self;
}

- (RACSignal *)next{
    if (self.fetching)
        return [RACSignal error:[NSError errorWithDomain:[InfoService errorDomain]
                                                    code:ErrAlreadyFetching
                                                userInfo:@{NSLocalizedDescriptionKey: @"Already fetching users."}]];
    
    __weak typeof(self)weakSelf = self;
    self.fetching = YES;
    NSMutableURLRequest *req = [self.client requestWithMethod:@"GET"
                                                         path:@"/users"
                                                   parameters:@{@"since":[@(self.since) stringValue]}];
    __block NSString *lastSinceHeader = nil;
    return [[[self.client enqueueRequest:req
                            resultClass:[OCTEntity class]
                           fetchAllPages:NO]
            doNext:^(OCTResponse *response){
                lastSinceHeader = response.HTTPURLResponse.allHeaderFields[@"Link"];
            }] doCompleted:^{
//                Process last response header to find since
                weakSelf.since = [[lastSinceHeader stringBetweenString:@"?since="
                                                            andString:@">;"] integerValue];
                weakSelf.fetching = NO;
                lastSinceHeader = nil;
            }];
}

@end
