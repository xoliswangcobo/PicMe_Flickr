//
//  PlacePhotoTableViewCell.h
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/24.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacePhotoTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UIImageView * photoThumbnail;
    @property (weak, nonatomic) IBOutlet UILabel * photoTitle;
@end
