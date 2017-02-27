//
//  LocationPhotosMapViewController.h
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/27.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface LocationPhotosMapViewController : BaseViewController
    @property (strong, nonatomic) NSArray * locationPhotos;
    @property (strong, nonatomic) NSMutableArray * locationPhotosCache;
@end
