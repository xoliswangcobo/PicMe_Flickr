//
//  Utilities.h
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/23.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface Utilities : NSObject

+ (void) downloadDataWithURL:(NSString*) dataURLString success:(void (^) (id responseData)) success failure:(void (^) (NSError * error)) failure;

@end
