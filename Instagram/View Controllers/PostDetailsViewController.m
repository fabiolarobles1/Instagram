//
//  PostDetailsViewController.m
//  Instagram
//
//  Created by Fabiola E. Robles Vega on 7/7/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "InstaPostTableViewCell.h"
#import "PostView.h"
@import Parse;



@interface PostDetailsViewController ()
@property (weak, nonatomic) IBOutlet PostView *postView;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    NSLog(@"POST: %@", self.post);
    [super viewDidLoad];
    
    [self.postView initWithPost];
    [self.postView setPost:self.post];
    
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
