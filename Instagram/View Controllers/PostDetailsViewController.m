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
//@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
//@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
//@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet PostView *postView;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    NSLog(@"POST: %@", self.post);
    [super viewDidLoad];
    
    [self.postView initWithPost];
    [self.postView setPost:self.post];
    
//    self.postImageView.file = self.post[@"image"];
//    [self.postImageView loadInBackground];
//    
//    self.captionLabel.text = self.post.caption;
//    self.usernameLabel.text = self.post.author.username;
//    
//    NSDate *createdAt = self.post.createdAt;
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//     
//     //Configure the input format to parse the date string
//      // formatter.dateFormat = @"E MM d HH:mm Z y";
//     
//     formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
//     
//     //Convert string to date
////     NSDate *date = [formatter dateFromString:createdAtOriginalString];
//    
//     //configure output format
//     formatter.dateStyle = NSDateFormatterShortStyle;
//     formatter.timeStyle = NSDateFormatterShortStyle;
//    
//    self.timeStampLabel.text = [formatter stringFromDate:createdAt];
    
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
