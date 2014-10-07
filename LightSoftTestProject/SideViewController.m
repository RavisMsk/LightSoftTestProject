//
//  SideViewController.m
//  LightSoftTestProject
//
//  Created by Nikita Anisimov on 06/10/14.
//  Copyright (c) 2014 Nikita Anisimov. All rights reserved.
//

#import "SideViewController.h"

#import "HistoryTableViewCell.h"
#import "HistoryCache.h"
#import "UsersFetcher.h"
#import "CentralViewController.h"

#import <OctoKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <IIViewDeckController.h>
#import <SVProgressHUD.h>

@interface SideViewController () <UISearchBarDelegate>

@property (nonatomic,weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic) BOOL searching;

@end

@implementation SideViewController{
    RACDisposable *oldSignal;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.searching = NO;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44);
    
    self.searchResults = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return !self.searching?[HistoryCache history].count:self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 80.0)];
    v.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 160, 30)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic"
                                 size:23.0];
    title.textColor = [UIColor whiteColor];
    title.text = @"History:";
    [v addSubview:title];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"HistoryCell";
    HistoryTableViewCell *cell = !self.searching ? [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath] : [tableView dequeueReusableCellWithIdentifier:cellId];
    OCTEntity *entity = !self.searching ? [HistoryCache history][indexPath.row] : self.searchResults[indexPath.row];
    ((HistoryTableViewCell*)cell).unameLabel.text = entity.login;
    ((HistoryTableViewCell*)cell).repoCountLabel.text = entity.email;
    [((HistoryTableViewCell*)cell).avatarImgView setImageWithURL:entity.avatarURL
                                                placeholderImage:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTEntity *entity = !self.searching ? [HistoryCache history][indexPath.row] : self.searchResults[indexPath.row];
    
    UINavigationController *central = (UINavigationController*)self.viewDeckController.centerController;
    if (![central.topViewController isKindOfClass:[CentralViewController class]])
        [central popToRootViewControllerAnimated:NO];
    
    [central.topViewController performSegueWithIdentifier:@"GoDetail"
                                                   sender:entity];
    
    [self.viewDeckController closeLeftViewAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

#pragma mark - Search

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searching = YES;
    [self.tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.searching = NO;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0){
        return;
    }
    
    [self.searchResults removeAllObjects];
    if (![oldSignal isDisposed]){
        [oldSignal dispose];
    }
    oldSignal = [[UsersFetcher fetchUsersWithQuery:searchText] subscribeNext:^(OCTResponse *resp) {
        [self.searchResults addObject:resp.parsedResult];
    } error:^(NSError *error) {
        NSLog(@"%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == 674){
                [SVProgressHUD showErrorWithStatus:@"Github API rate limit exceeded."];
                
            }
            [self.tableView reloadData];
        });
    } completed:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

@end
