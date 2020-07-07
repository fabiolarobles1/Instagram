//
//  ComposeViewController.m
//  Instagram
//
//  Created by Fabiola E. Robles Vega on 7/7/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "ComposeViewController.h"
#import "FeedViewController.h"
#import "SceneDelegate.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapCancel:(id)sender {
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedViewController *feedViewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticatedViewController"];
    myDelegate.window.alpha = 0.25;
    myDelegate.window.rootViewController = feedViewController;
    
    [UIView animateWithDuration:1 animations:^{
        myDelegate.window.alpha = 1;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
