//
//  LocationPhotosViewController.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/22.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "LocationPhotosViewController.h"
#import "FlickrAPIManager.h"
#import "DetailedPhotoViewController.h"
#import "PlacePhotoTableViewCell.h"

@interface LocationPhotosViewController () <UITableViewDelegate, UITableViewDataSource>
    @property (weak, nonatomic) IBOutlet UITableView * locationPhotosTableView;
    @property (strong, nonatomic) NSMutableArray * locationPhotosTableViewPhotos;
@end

@implementation LocationPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init optimisation photos array
    self.locationPhotosTableViewPhotos = [NSMutableArray array];
    for (NSInteger index = 0; index < [self.locationPhotos count]; index++) {
        [self.locationPhotosTableViewPhotos addObject:[NSNull null]];
    }
}


#pragma mark - TableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.locationPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlacePhotoTableViewCell * thePhotoCell;
    thePhotoCell = [tableView dequeueReusableCellWithIdentifier:@"locationPhotoCell"];
    
    if (thePhotoCell) {
        NSDictionary * thePhotoData = [self.locationPhotos objectAtIndex:indexPath.row];
        thePhotoCell.photoTitle.text = [thePhotoData valueForKey:@"title"];
        
        if ([self.locationPhotosTableViewPhotos[indexPath.row] isKindOfClass:[UIImage class]] == YES) {
            thePhotoCell.photoThumbnail.image = self.locationPhotosTableViewPhotos[indexPath.row];
        } else {
            [FlickrAPIManager photoWithID:[thePhotoData valueForKey:@"id"] quality:FlickrAPIManagerPhotoQualityThumbnail success:^(id responseData) {
                NSLog(@"Data: %@", responseData);
                self.locationPhotosTableViewPhotos[indexPath.row] = [[UIImage alloc] initWithData:responseData];
                thePhotoCell.photoThumbnail.image = self.locationPhotosTableViewPhotos[indexPath.row];
            } failure:^(NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
    }
    
    return thePhotoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * selectedPhotoData = [self.locationPhotos objectAtIndex:indexPath.row];
    
    [self showLoadingProgressIndicatorWithMessage:@"Downloading..."];
    
    [FlickrAPIManager photoWithID:[selectedPhotoData valueForKey:@"id"] quality:FlickrAPIManagerPhotoQualityLarge success:^(id responseData) {
        [self dismissLoadingProgressIndicator];
        DetailedPhotoViewController * detailedPhotoViewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"DetailedPhotoViewController"];
        detailedPhotoViewController.photoOtherData = selectedPhotoData;
        detailedPhotoViewController.photoImageData = responseData;
        [self.navigationController pushViewController:detailedPhotoViewController animated:YES];
    } failure:^(NSError *error) {
        [self dismissLoadingProgressIndicator];
        void (^okayActionBlock)() = ^ {};
        [self presentModalMessageWithTitle:@"Download" message:error.localizedDescription buttonTitles:@[@"Okay"] buttonActions:@[[okayActionBlock copy]]];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
