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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onTapSignUpButton:(id)sender {
    
            [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
        
    
    
    
}

@end
