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

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    [UIView animateWithDuration:3 animations:^{
        myDelegate.window.alpha = 1;
    }];
}
- (IBAction)didTapCompose:(id)sender {
     [self performSegueWithIdentifier:@"toComposeSegue" sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    InstaPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstaPostCell" ];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

@end
