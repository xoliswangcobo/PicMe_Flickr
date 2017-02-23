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
    
    [LocationManager currentLocationWithSuccess:^(NSInteger latitude, NSInteger longitude) {
        [self dismissLoadingProgressIndicator];
         [self showLoadingProgressIndicatorWithMessage:@"Getting Photos..."];
        
        [FlickrAPIManager photosForLocationWithLatitude:latitude longitude:longitude resultLimit:30 success:^(NSDictionary *responseDictionary) {
            [self dismissLoadingProgressIndicator];
            [self performSegueWithIdentifier:@"showGroup" sender:sender];
        } failure:^(NSError *error) {
            [self dismissLoadingProgressIndicator];
            
            void (^okayActionBlock)() = ^ {
                
            };
            
            [self presentModalMessageWithTitle:@"Get Photos" message:error.localizedDescription buttonTitles:@[@"Okay"] buttonActions:@[[okayActionBlock copy]]];
        }];
    } failure:^(NSError *error) {
        [self dismissLoadingProgressIndicator];
        
        void (^okayActionBlock)() = ^ {
        
        };
        
        [self presentModalMessageWithTitle:@"Latest Location" message:error.localizedDescription buttonTitles:@[@"Okay"] buttonActions:@[[okayActionBlock copy]]];
    }];
}

@end
