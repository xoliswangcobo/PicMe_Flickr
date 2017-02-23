//
//  FlickrAPIManager.h
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/23.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrAPIManager : NSObject

+ (FlickrAPIManager*) sharedManager;
+ (void) resetManager;
+ (void) photosForLocationWithLatitude:(NSInteger) latitude  longitude:(NSInteger) longitude resultLimit:(NSInteger) limit failure:(void (^) (NSError * error)) failure success:(void (^) (NSDictionary * responseDictionary)) success;

@end
