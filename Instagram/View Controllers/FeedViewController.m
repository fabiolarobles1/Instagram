//
//  FeedViewController.m
//  Instagram
//
//  Created by Fabiola E. Robles Vega on 7/7/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "InstaPostTableViewCell.h"
#import "Post.h"
#import "PostDetailsViewController.h"
#import "InfiniteScrollActivityView.h"
#import "DateTools.h"

@interface FeedViewController () 

@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;

@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int skipcount;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.skipcount = 0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.isMoreDataLoading = NO;
    [self fetchPosts];
    
    //setting up refresh control
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tableView addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    
}


-(void)fetchPosts{
    //NSLog(@"END: %d and refreshinf %d",reachedEnd, [self.refreshControl isRefreshing]);
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    if(self.isMoreDataLoading && self.posts.count>self.skipcount ){
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


- (IBAction)didTapLogout:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error ==nil){
            NSLog(@"Successfully logged out user.");
        }
        else{
            NSLog(@"Error loggin out user.");
        }
    }];
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.alpha = 0.50;
    myDelegate.window.rootViewController = loginViewController;
    
    [UIView animateWithDuration:2 animations:^{
        myDelegate.window.alpha = 1;
    }];
}


- (IBAction)didTapCompose:(id)sender {
    [self performSegueWithIdentifier:@"toComposeSegue" sender:nil];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //Unselect post cell after entering details
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InstaPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstaPostCell" ];
    Post *post = self.posts[indexPath.row];
    
    [cell setPost:post];
    cell.captionLabel.text = post.caption;
    cell.usernameLabel.text = post.author.username;
    cell.dateLabel.text = [post.createdAt.shortTimeAgoSinceNow stringByAppendingString:@" ago"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Number of posts: %ld", self.posts.count);
    
    return self.posts.count;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.skipcount +=20;
            self.isMoreDataLoading = YES;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            //load more results
            if (self.posts.count>self.skipcount){
                [self fetchPosts];
            }else{
                [self.loadingMoreView stopAnimating];
                self.isMoreDataLoading = NO;
            }
        }
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"toDetailsViewSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        PostDetailsViewController *detailViewController = [segue destinationViewController];
        detailViewController.post = post;
        NSLog(@"%@", post[@"createdAt"]);
        
    }
}

@end
