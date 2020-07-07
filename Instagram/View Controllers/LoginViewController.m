//
//  ViewController.m
//  Instagram
//
//  Created by Fabiola E. Robles Vega on 7/6/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSignUpButton:(id)sender {
    [self performSegueWithIdentifier:@"toSignUpSegue" sender:nil];
}


- (IBAction)didTapLoginButton:(id)sender {
    if (!self.usernameField.hasText || !self.passwordField.hasText ){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Required Fields" message:@"Username and password are required to login. Please fill all the information." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{ }];
        
    }else{
        [self loginUser];
    }
}

-(void) loginUser{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"User login failed : %@" , error.description);
            if(error.code == 101){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid username/password" message:@"The username or password do not match. Try Again." preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.usernameField.text = @"";
                    self.passwordField.text = @"";
                }];
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:^{ }];
                
            }
        }else{
            NSLog(@"User logged in successfully.");
            [self performSegueWithIdentifier:@"toFeedSegue" sender:nil];
        }
    }];
}

@end
