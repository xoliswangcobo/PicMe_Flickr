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
    @property (nonatomic, copy) void (^locationUpdateCompletionBlock) (NSInteger longitude, NSInteger latitude);
    @property (strong, nonatomic) CLLocationManager * locationManager;
@end

@implementation LocationManager

#pragma mark - Manager Singleton

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.locationUpdateCompletionBlock = nil;
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

+ (void) currentLocationWithCompletion:(void (^) (NSInteger longitude, NSInteger latitude)) completion {
    if (completion) {
        [LocationManager sharedManager].locationUpdateCompletionBlock = completion;
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
    
    if ([LocationManager sharedManager].locationUpdateCompletionBlock) {
        [LocationManager sharedManager].locationUpdateCompletionBlock(theLocation.coordinate.latitude, theLocation.coordinate.longitude);
        [LocationManager sharedManager].locationUpdateCompletionBlock = nil;
    }
}

@end
