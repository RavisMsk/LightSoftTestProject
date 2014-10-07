//
//  UserTableViewCell.h
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 07/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCTEntity;

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

@property (nonatomic, weak) OCTEntity *user;

@end
