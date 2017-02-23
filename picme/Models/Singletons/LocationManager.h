//
//  LocationManager.h
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/22.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

+ (LocationManager*) sharedManager;
+ (void) resetManager;

+ (void) currentLocationWithSuccess:(void (^) (float latitude, float longitude)) completion failure:(void (^) (NSError * error)) failure;
+ (void) placesNearbyLatitude:(float) latitude longitude:(float) longitude success:(void (^) (NSDictionary * responseDictionary)) success failure:(void (^) (NSError * error)) failure;
+ (void) placeIconWithURL:(NSString*) iconURL success:(void (^) (id responseData)) success failure:(void (^) (NSError * error)) failure;

@end
