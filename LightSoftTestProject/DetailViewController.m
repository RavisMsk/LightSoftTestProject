//
//  DetailViewController.m
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 07/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import "DetailViewController.h"

#import "UsersFetcher.h"
#import "HistoryCache.h"

#import <SVProgressHUD.h>
#import <OctoKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *repoCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *repoTable;

@property (nonatomic, strong) NSMutableArray *repos;

@end

@implementation DetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.repos = [NSMutableArray array];
    
    self.avatarView.layer.cornerRadius = 45.0;
    self.avatarView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.avatarView.layer.borderWidth = 1.0;
    self.avatarView.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.githubUser.login;
    self.loginLabel.text = self.githubUser.login;
    [self.avatarView setImageWithURL:self.githubUser.avatarURL
                    placeholderImage:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.repos.count == 0){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[UsersFetcher fetchUserReposWithUser:self.githubUser]
         subscribeNext:^(OCTRepository *repo) {
             [self.repos addObject:repo];
         } error:^(NSError *error) {
             NSLog(@"%@", error);
             [SVProgressHUD showErrorWithStatus:@"Error."];
         } completed:^{
    //         Dunno why this completed block is called on another thread, but explicitly sending UI ops to main thread saved situation
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.repoCountLabel.text = [NSString stringWithFormat:@"%lu repositories", (unsigned long)self.repos.count];
                 [self.repoTable reloadData];
                 [SVProgressHUD dismiss];
                 
                 [HistoryCache pushToHistoryWithEntity:self.githubUser
                                            reposCount:self.repos.count];
                 
             });
         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.repos.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Public repositories:";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"RepoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin"
                                              size:20.0];
    }
    OCTRepository *repo = self.repos[indexPath.row];
    cell.textLabel.text = repo.name;
    return cell;
}

@end
