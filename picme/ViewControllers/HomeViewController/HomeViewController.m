//
//  HomeViewController.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/22.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "HomeViewController.h"
#import "LocationPhotosViewController.h"
#import "PlaceTableViewCell.h"
#import "Utilities.h"

@interface HomeViewController() <UITableViewDataSource, UITableViewDelegate>
    @property (strong, nonatomic) NSArray * nearByPlaces;
    @property (weak, nonatomic) IBOutlet UITableView * nearByPlacesTableView;
    @property (nonatomic, strong) UIRefreshControl * pullTableViewToRefreshControl;

    @property (strong, nonatomic) NSArray * selectedLocationPhotoData;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pullTableViewToRefreshControl = [[UIRefreshControl alloc] init];
    [self.pullTableViewToRefreshControl addTarget:self action:@selector(loadLocationData) forControlEvents:UIControlEventValueChanged];
    [self.nearByPlacesTableView addSubview:self.pullTableViewToRefreshControl];
    
    [self loadLocationData];
}

- (void) loadLocationData {
    [self showLoadingProgressIndicatorWithMessage:@"Getting Location..."];
    
    if ([self.pullTableViewToRefreshControl isRefreshing]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pullTableViewToRefreshControl endRefreshing];
        });
    }
    
    [LocationManager currentLocationWithSuccess:^(float latitude, float longitude) {
        [self dismissLoadingProgressIndicator];
        [self showLoadingProgressIndicatorWithMessage:@"Getting Places..."];
        
        [LocationManager placesNearbyLatitude:latitude longitude:longitude success:^(NSDictionary *responseDictionary) {
            self.nearByPlaces = [responseDictionary objectForKey:@"results"];
            [self.nearByPlacesTableView reloadData];
            [self dismissLoadingProgressIndicator];
        } failure:^(NSError *error) {
            [self dismissLoadingProgressIndicator];
            void (^okayActionBlock)() = ^ {};
            [self presentModalMessageWithTitle:@"Get Places" message:error.localizedDescription buttonTitles:@[@"Okay"] buttonActions:@[[okayActionBlock copy]]];
        }];
    } failure:^(NSError *error) {
        [self dismissLoadingProgressIndicator];
        void (^okayActionBlock)() = ^ {};
        [self presentModalMessageWithTitle:@"Location Update" message:error.localizedDescription buttonTitles:@[@"Okay"] buttonActions:@[[okayActionBlock copy]]];
    }];
}

#pragma mark - Tableview DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nearByPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceTableViewCell * theCell;
    theCell = [tableView dequeueReusableCellWithIdentifier:@"placeCell"];
    
    if (theCell) {
        NSDictionary * placeData = [self.nearByPlaces objectAtIndex:indexPath.row];
        theCell.placeName.text = [placeData valueForKey:@"name"];
        theCell.placeVacinity.text = [placeData valueForKey:@"vicinity"];
        
        [Utilities downloadDataWithURL:[placeData valueForKey:@"icon"] success:^(id responseData) {
            theCell.placeIcon.image = [[UIImage alloc] initWithData:responseData];
        } failure:^(NSError *error) {
            
        }];
    }
    
    return theCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * selectedData = [self.nearByPlaces objectAtIndex:indexPath.row];
    NSDictionary * locationData = [[selectedData objectForKey:@"geometry"] objectForKey:@"location"];
    
    [self showLoadingProgressIndicatorWithMessage:@"Getting Photos..."];
    
    [FlickrAPIManager photosForLocationWithLatitude:[[locationData valueForKey:@"lat"] floatValue] longitude:[[locationData valueForKey:@"lng"] floatValue] resultLimit:30 success:^(NSDictionary *responseDictionary) {
        [self dismissLoadingProgressIndicator];
        self.selectedLocationPhotoData = [[responseDictionary objectForKey:@"photos"] objectForKey:@"photo"];
        [self performSegueWithIdentifier:@"showGroup" sender:[tableView indexPathForSelectedRow]];
    } failure:^(NSError *error) {
        [self dismissLoadingProgressIndicator];
        void (^okayActionBlock)() = ^ {};
        [self presentModalMessageWithTitle:@"Get Photos" message:error.localizedDescription buttonTitles:@[@"Okay"] buttonActions:@[[okayActionBlock copy]]];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGroup"]) {
        LocationPhotosViewController * locationPhotosViewController = segue.destinationViewController;
        locationPhotosViewController.locationPhotos = self.selectedLocationPhotoData;
    }
}

@end
