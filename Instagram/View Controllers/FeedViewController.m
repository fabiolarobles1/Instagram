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

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource >

@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

-(void)fetchPosts{
    
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"createdAt"];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
           
            self.posts= [posts mutableCopy];
                [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            } else {
                NSLog(@"%@", error.localizedDescription);
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
    
   // AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
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
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Number of posts: %ld", self.posts.count);
    
    return self.posts.count;
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
