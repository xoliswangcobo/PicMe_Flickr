//
//  LocationPhotosViewController.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/22.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "LocationPhotosViewController.h"

@interface LocationPhotosViewController () <UITableViewDelegate, UITableViewDataSource>
    @property (weak, nonatomic) IBOutlet UITableView * locationPhotosTableView;
@end

@implementation LocationPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - TableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.locationPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * thePhotoCell;
    thePhotoCell = [tableView dequeueReusableCellWithIdentifier:@"locationPhotoCell"];
    
    if (thePhotoCell) {
        NSDictionary * thePhotoData = [self.locationPhotos objectAtIndex:indexPath.row];
        thePhotoCell.textLabel.text = [thePhotoData valueForKey:@"title"];
    }
    
    return thePhotoCell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
