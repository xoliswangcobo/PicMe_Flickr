//
//  DetailedPhotoViewController.h
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/22.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "BaseViewController.h"

@interface DetailedPhotoViewController : BaseViewController
    @property (strong, nonatomic) NSData * photoImageData;
    @property (strong, nonatomic) NSDictionary * photoOtherData;
@end
