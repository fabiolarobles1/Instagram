//
//  PostView.m
//  Instagram
//
//  Created by Fabiola E. Robles Vega on 7/9/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "PostView.h"
#import "Post.h"
#import "DateTools.h"
@import Parse;

@interface PostView ()
@property (strong, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end

@implementation PostView

-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if(self){
        [self initWithPost];
    }
    return self;
}


-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self initWithPost];
    }
    
    return self;
}

-(void) initWithPost{
    
    //grabbing xib
    [[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil];
    
    //adding the content view as a subview of class
    [self addSubview:self.postView];
    
    //contrain xib so it takes entire view
    self.postView.frame = self.bounds;
    
}


-(void)setPost:(Post *)post{
    _post = post;
    
    self.usernameLabel.text = post.author.username;
    
    self.postImageView.file = post[@"image"];
    [self.postImageView loadInBackground];
    
    NSDate *createdAt = post.createdAt;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //Configure the input format to parse the date string
    // formatter.dateFormat = @"E MM d HH:mm Z y";
    
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    //Convert string to date
    
    
    //configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.dateLabel.text = [createdAt.shortTimeAgoSinceNow stringByAppendingString:@" ago"];
    //self.dateLabel.text = [formatter stringFromDate:createdAt];
    
    self.captionLabel.text = post.caption;
    
    
}



@end
