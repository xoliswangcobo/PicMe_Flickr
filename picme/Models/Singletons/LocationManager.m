//
//  LocationManager.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/22.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "LocationManager.h"
#import "AFNetworking.h"
#import "Utilities.h"

#define PLACES_API_KEY @""
#define PLACES_API_NEARBYSEARCH_URL @"https://maps.googleapis.com/maps/api/place/nearbysearch/json"

static LocationManager * sharedManager_;

@interface LocationManager()
    @property (nonatomic, copy) void (^locationUpdateSuccessBlock) (float latitude, float longitude);
    @property (nonatomic, copy) void (^locationUpdateFailureBlock) (NSError * error);
    @property (strong, nonatomic) CLLocationManager * locationManager;
@end

@implementation LocationManager

#pragma mark - Manager Singleton

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.locationUpdateSuccessBlock = nil;
        self.locationUpdateFailureBlock = nil;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    return self;
}

+ (LocationManager*) sharedManager {
    
    if (sharedManager_ == nil) {
        sharedManager_ = [LocationManager new];
    }
    
    return sharedManager_;
}

+ (void) resetManager {
    sharedManager_ = nil;
}

+ (void) currentLocationWithSuccess:(void (^) (float latitude, float longitude)) success failure:(void (^) (NSError * error)) failure {
    if (success) {
        [LocationManager sharedManager].locationUpdateSuccessBlock = success;
    }
    
    if (failure) {
        [LocationManager sharedManager].locationUpdateFailureBlock = failure;
    }
    
    [LocationManager sharedManager].locationManager.distanceFilter = kCLDistanceFilterNone;
    [LocationManager sharedManager].locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [[LocationManager sharedManager].locationManager requestWhenInUseAuthorization];

    [[[LocationManager sharedManager] locationManager] startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [[[LocationManager sharedManager] locationManager] stopUpdatingLocation];
    CLLocation * theLocation = [locations firstObject];
    
    if ([LocationManager sharedManager].locationUpdateSuccessBlock) {
        [LocationManager sharedManager].locationUpdateSuccessBlock(theLocation.coordinate.latitude, theLocation.coordinate.longitude);
    }
    
    [LocationManager sharedManager].locationUpdateSuccessBlock = nil;
    [LocationManager sharedManager].locationUpdateFailureBlock = nil;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [[[LocationManager sharedManager] locationManager] stopUpdatingLocation];
    
    if ([LocationManager sharedManager].locationUpdateFailureBlock) {
        [LocationManager sharedManager].locationUpdateFailureBlock(error);
    }
    
    [LocationManager sharedManager].locationUpdateSuccessBlock = nil;
    [LocationManager sharedManager].locationUpdateFailureBlock = nil;
}

#pragma mark - Place API Data

+ (void) placesNearbyLatitude:(float) latitude longitude:(float) longitude success:(void (^) (NSDictionary * responseDictionary)) success failure:(void (^) (NSError * error)) failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:PLACES_API_NEARBYSEARCH_URL parameters:@{ @"key" : PLACES_API_KEY, @"location" : [NSString stringWithFormat:@"%f,%f", latitude, longitude], @"type" : @"shopping_mall", @"radius" : @"5000" } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if(failure) {
            failure(error);
        }
    }];
}

+ (void) placeIconWithURL:(NSString*) iconURL success:(void (^) (id responseData)) success failure:(void (^) (NSError * error)) failure {
    [Utilities downloadDataWithURL:iconURL success:^(id responseData) {
        if (success) {
            success(responseData);
        }
    } failure:failure];
}

@end
