//
//  StyleService.m
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 07/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import "StyleService.h"

#import <UIColor+MLPFlatColors.h>

@implementation StyleService

+ (void)installStyles{
    [[UINavigationBar appearance] setBarTintColor:[UIColor flatDarkBlueColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor flatDarkBlackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin"
                                                                                                size:22.0],
                                                           NSForegroundColorAttributeName: [UIColor flatDarkBlackColor]
                                                           }];
    [[UIBarButtonItem appearance] setTintColor:[UIColor flatBlackColor]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-ThinItalic"
                                                                                                size:22.0],
                                                           NSForegroundColorAttributeName: [UIColor flatDarkBlackColor]
                                                           }
                                                forState:UIControlStateNormal];
}

@end
