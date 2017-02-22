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
}

- (IBAction)showGroup:(id)sender {
    [self showLoadingProgressIndicatorWithMessage:@"Updating Location..."];
    
    [LocationManager currentLocationWithSuccess:^(NSInteger longitude, NSInteger latitude) {
        
        // Avoiding too fast glitchish animation - not needed
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissLoadingProgressIndicator];
            [self performSegueWithIdentifier:@"showGroup" sender:sender];
        });
       
    } failure:^(NSError *error) {
        [self dismissLoadingProgressIndicator];
        
        void (^okayActionBlock)() = ^ {
        
        };
        
        [self presentModalMessageWithTitle:@"Latest Location" message:error.localizedDescription buttonTitles:@[@"Okay"] buttonActions:@[[okayActionBlock copy]]];
    }];
}

@end
