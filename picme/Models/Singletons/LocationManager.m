//
//  LocationManager.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/22.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "LocationManager.h"

static LocationManager * sharedManager_;

@interface LocationManager()
    @property (nonatomic, copy) void (^locationUpdateSuccessBlock) (NSInteger longitude, NSInteger latitude);
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

+ (void) currentLocationWithSuccess:(void (^) (NSInteger longitude, NSInteger latitude)) success failure:(void (^) (NSError * error)) failure {
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

@end
