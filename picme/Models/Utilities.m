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
    NSURL *URL = [NSURL URLWithString:dataURLString];
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            if(failure) {
//                failure(error);
//            }
//        } else {
//            NSLog(@"%@ %@", response, responseObject);
//            if (success) {
//                success(responseObject);
//            }
//        }
//    }];
//    
//    [dataTask resume];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection
     sendAsynchronousRequest:request
                       queue:[NSOperationQueue mainQueue]
           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
               if (!error) {
                   if (success) {
                       success(data);
                   }
               } else{
                   if(failure) {
                       failure(error);
                   }
               }
           }];
}

@end
