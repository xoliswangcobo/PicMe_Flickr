//
//  DetailedPhotoViewController.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/22.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "DetailedPhotoViewController.h"

@interface DetailedPhotoViewController ()
    @property (weak, nonatomic) IBOutlet UIImageView * photo;
    @property (weak, nonatomic) IBOutlet UILabel * photoTitle;
@end

@implementation DetailedPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.photo.image = [[UIImage alloc] initWithData:self.photoImageData];
    self.photoTitle.text = [self.photoOtherData valueForKey:@"title"];
    self.photo.contentMode = UIViewContentModeScaleAspectFit;
}

@end
