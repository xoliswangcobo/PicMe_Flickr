//
//  FlickrAPIManager.h
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/23.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FlickrAPIManagerPhotoQuality) {
    FlickrAPIManagerPhotoQualityThumbnail = 0,
    FlickrAPIManagerPhotoQualitySmall,
    FlickrAPIManagerPhotoQualityMedium,
    FlickrAPIManagerPhotoQualityLarge,
    FlickrAPIManagerPhotoQualityOriginal
};

@interface FlickrAPIManager : NSObject

+ (FlickrAPIManager*) sharedManager;
+ (void) resetManager;
+ (void) photosForLocationWithLatitude:(float) latitude  longitude:(float) longitude resultLimit:(NSInteger) limit success:(void (^) (NSDictionary * responseDictionary)) success failure:(void (^) (NSError * error)) failure;
+ (void) photosWithID:(NSString*) photoID quality:(FlickrAPIManagerPhotoQuality) quality success:(void (^) (id responseData)) success failure:(void (^) (NSError * error)) failure;

@end
