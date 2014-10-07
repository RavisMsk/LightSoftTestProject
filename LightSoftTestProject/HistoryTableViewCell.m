//
//  HistoryTableViewCell.m
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 07/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.avatarImgView.layer.cornerRadius = 20.0;
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.avatarImgView.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
