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
#import <Parse/Parse.h>
#import "Post.h"
#import "MBProgressHUD.h"


@interface ComposeViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UITextField *captionField;
@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;

@end

@implementation ComposeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    //Future feature: ADDING POP UP TO PICK FROM CAMERA OR ROLL
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    
    
    //Future feature:ADDING SELECT ORIGINAL OR EDITED
    self.postImageView.image = editedImage;
    //[self resizeImage:editedImage withSize:CGSizeMake(960, 1440)];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (IBAction)didTapCancel:(id)sender {
    [self toFeed];
}

//to avoid multiple post of same picture
-(IBAction)disablePostButton{
    self.postButton.enabled = !self.postButton.enabled;
}


- (IBAction)didTapPost:(id)sender {
    
    [self disablePostButton];
    // Display HUD right before the request is made
    [ MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [Post postUserImage:self.postImageView.image withCaption:self.captionField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Succesfully posted image.");
            [ MBProgressHUD hideHUDForView:self.view animated:YES];
            [self toFeed];
            [self disablePostButton];
        }
    }];
    NSLog(@"Tapping post.");
}


-(void) toFeed{
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
