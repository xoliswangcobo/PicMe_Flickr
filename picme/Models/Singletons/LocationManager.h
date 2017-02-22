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

+ (void) currentLocationWithCompletion:(void (^) (NSInteger longitude, NSInteger latitude)) completion;

@end
