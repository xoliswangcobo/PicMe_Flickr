//
//  HomeViewController.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/22.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Started!!");
}

- (IBAction)showGroup:(id)sender {
    [self showLoadingProgressIndicatorWithMessage:@"Updating Location..."];
    
    [LocationManager currentLocationWithSuccess:^(NSInteger longitude, NSInteger latitude) {
        [self dismissLoadingProgressIndicator];
        [self performSegueWithIdentifier:@"showGroup" sender:sender];
    } failure:^(NSError *error) {
        [self dismissLoadingProgressIndicator];
        
        void (^okayActionBlock)() = ^ {
        
        };
        
        [self presentModalMessageWithTitle:@"Latest Location" message:error.localizedDescription buttonTitles:@[@"Okay"] buttonActions:@[[okayActionBlock copy]]];
    }];
}

@end
