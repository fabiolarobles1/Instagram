//
//  SignUpViewController.m
//  Instagram
//
//  Created by Fabiola E. Robles Vega on 7/6/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "LoginViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:YES];
}


- (IBAction)didTapSignUp:(id)sender {

    if (!self.usernameField.hasText || !self.passwordField.hasText || !self.emailField.hasText){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Required Fields" message:@"Email, Username, and password are required to create an account. Please fill all the information." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{ }];
        
    }else{
        [self registerUser];
    }
}


-(void) registerUser{
    
    //initializing user
    PFUser *newUser = [PFUser user];
    
    //setting up properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    //call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error !=nil){
            NSLog(@"Sign up user error: %@", error.description);
          
            if(error.code == 125){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Email" message:@"Email address format is invalid." preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.emailField.text = @"";
                }];
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:^{ }];
                
            }else if(error.code == 202){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Username" message:@"Account already exists for this username." preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.usernameField.text = @"";
                }];
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:^{ }];
            }else if(error.code == 203){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Email" message:@"Account already exists for this email adress." preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.emailField.text = @"";
                }];
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:^{ }];
            }
        }else{
            NSLog(@"User registered succesfully.");
            
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            myDelegate.window.alpha = 0;
            myDelegate.window.rootViewController = loginViewController;
            
            [UIView animateWithDuration:3 animations:^{
                myDelegate.window.alpha = 1;
            }];
        }
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
