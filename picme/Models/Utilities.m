//
//  Utilities.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/23.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

#pragma mark - Utilities

+ (void) downloadDataWithURL:(NSString*) dataURLString success:(void (^) (id responseData)) success failure:(void (^) (NSError * error)) failure {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:dataURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if(failure) {
                failure(error);
            }
        } else {
            NSLog(@"%@ %@", response, responseObject);
            if (success) {
                success(responseObject);
            }
        }
    }];
    
    [dataTask resume];
}

@end
