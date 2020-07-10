//
//  ProfileViewController.m
//  Instagram
//
//  Created by Fabiola E. Robles Vega on 7/9/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "ProfileViewController.h"
#import "FeedViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "PostCell.h"
#import "PostView.h"
#import "Post.h"
#import "PostDetailsViewController.h"
#import "InfiniteScrollActivityView.h"
#import "DateTools.h"


@interface ProfileViewController  () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int skipcount;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.skipcount = 0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelection = YES;
    self.isMoreDataLoading = NO;
    [self fetchPosts];
}


-(void)fetchPosts{
    
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"author"];
    [postQuery orderByDescending:@"createdAt"];
    
    postQuery.limit = 20;
    if(self.isMoreDataLoading ){
        postQuery.skip = self.skipcount;
    }
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            
            if(self.isMoreDataLoading){
                [self.posts addObjectsFromArray:posts];
            }else{
                self.posts= [posts mutableCopy];
            }
            //update flag
            self.isMoreDataLoading = NO;
            
            // stop indicators
            [self.refreshControl endRefreshing];
            [self.loadingMoreView stopAnimating];
            
            [self.tableView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Load Feed" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
            
            //creating cancel action
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // doing nothing will dismiss the view
            }];
            //   adding cancel action to the alertController
            [alert addAction:cancelAction];
            
            //creating OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //try to load movies again
                [self fetchPosts];
            }];
            
            //adding OK action to the alertController
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                [self.refreshControl endRefreshing];
                [self.loadingMoreView stopAnimating];
            }];
        }
    }];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //Unselect post cell after entering details
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    [cell addSubview: cell.postView];
    Post *post = self.posts[indexPath.row];
    [cell.postView setPost:post];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
}

@end
