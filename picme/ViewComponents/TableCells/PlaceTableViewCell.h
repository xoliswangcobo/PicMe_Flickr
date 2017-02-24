//
//  PlaceTableViewCell.h
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/24.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceTableViewCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UIImageView * placeIcon;
    @property (weak, nonatomic) IBOutlet UILabel * placeName;
    @property (weak, nonatomic) IBOutlet UILabel * placeVacinity;
@end
