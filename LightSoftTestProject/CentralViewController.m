//
//  CentralViewController.m
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 06/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import "CentralViewController.h"

#import "UsersFetcher.h"
#import "UserTableViewCell.h"
#import "DetailViewController.h"

#import <OctoKit.h>

@interface CentralViewController ()

@property (nonatomic, strong) UsersFetcher *fetcher;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic) NSUInteger selectedUser;

- (void)refreshTrigger;

@end

@implementation CentralViewController

- (void)refreshTrigger{
    self.fetcher = nil;
    self.fetcher = [UsersFetcher new];
    self.users = nil;
    self.users = [NSMutableArray array];
    [self.tableView reloadData];
    
    [self.refreshControl beginRefreshing];
    [[self.fetcher next] subscribeNext:^(OCTResponse *response){
        [self.users addObject:response.parsedResult];
    }error:^(NSError *err){
        NSLog(@"%@", err);
        [self.refreshControl endRefreshing];
    }completed:^{
        NSLog(@"Reloading with %lu users in list", self.users.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTrigger)
                  forControlEvents:UIControlEventValueChanged];
    
    [self refreshTrigger];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"UserCell";
    UserTableViewCell *cell = (UserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellId
                                                                                  forIndexPath:indexPath];
    OCTEntity *user = self.users[indexPath.row];
    cell.user = user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedUser = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

#pragma mark - Scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    const CGFloat deltaToLoad = 80.0f;
    if (scrollView.contentSize.height - scrollView.contentOffset.y - self.view.frame.size.height <= deltaToLoad){
//        Load more
        RACSignal *fetchSignal;
        fetchSignal = [self.fetcher next];
        [fetchSignal subscribeNext:^(OCTResponse *response){
            [self.users addObject:response.parsedResult];
        }error:^(NSError *err){
            NSLog(@"%@", err);
        }completed:^(){
            NSLog(@"Reloading with %lu users in list", self.users.count);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }
}

#pragma mark - Segue navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender{
    OCTEntity *user = nil;
    if ([sender isKindOfClass:[UserTableViewCell class]]){
        UserTableViewCell *cell = sender;
        user = cell.user;
    }else if ([sender isKindOfClass:[OCTEntity class]]){
        user = sender;
    }
    DetailViewController *detail = [segue destinationViewController];
    detail.githubUser = user;
}

@end
