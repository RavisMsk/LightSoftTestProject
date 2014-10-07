//
//  InfoService.m
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 07/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import "InfoService.h"

@implementation InfoService

+ (NSString *)errorDomain{
    return @"ru.NikitaAnisimov.LightSoftTestProject.error";
}

+ (NSString *)developer{
    return @"Nikita Anisimov <ravis.bmstu@gmail.com>";
}

+ (NSString *)version{
    return @"1.0";
}

@end
