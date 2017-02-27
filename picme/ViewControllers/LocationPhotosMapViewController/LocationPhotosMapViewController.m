//
//  LocationPhotosMapViewController.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/27.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "LocationPhotosMapViewController.h"
#import "DetailedPhotoViewController.h"
#import "FlickrAPIManager.h"

@interface LocationPhotoPointAnnotation : MKPointAnnotation
    @property (strong, nonatomic) NSDictionary * photoData;
@end

@implementation LocationPhotoPointAnnotation

@end

@interface LocationPhotosMapViewController () <MKMapViewDelegate>
    @property (weak, nonatomic) IBOutlet MKMapView * locationPhotosMapView;
    @property (strong, nonatomic) NSMutableArray * photoMapAnnotations;
    @property (nonatomic, assign) CLLocationCoordinate2D mainLocation;
@end

@implementation LocationPhotosMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary * firstPhotoData = [self.locationPhotos firstObject];
    self.mainLocation = CLLocationCoordinate2DMake([[firstPhotoData valueForKey:@"latitude"] floatValue], [[firstPhotoData valueForKey:@"longitude"] floatValue]);
    
    self.locationPhotosMapView.delegate = self;
    self.locationPhotosMapView.centerCoordinate = CLLocationCoordinate2DMake(self.mainLocation.latitude , self.mainLocation.longitude);
    [self.locationPhotosMapView setShowsUserLocation:YES];
    [self.view addSubview:self.locationPhotosMapView];
    
    [self prepareMapDataAndAnnotations];
    [self.locationPhotosMapView showAnnotations:self.photoMapAnnotations animated:NO];
}

- (void) prepareMapDataAndAnnotations {
    self.photoMapAnnotations = [NSMutableArray array];
    
    for (NSDictionary * photoDataDictionary in self.locationPhotos) {
        LocationPhotoPointAnnotation *annotation = [[LocationPhotoPointAnnotation alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake([[photoDataDictionary valueForKey:@"latitude"] floatValue], [[photoDataDictionary valueForKey:@"longitude"] floatValue])];
        annotation.photoData = photoDataDictionary;
        [self.photoMapAnnotations addObject:annotation];
    }
    
    [self.locationPhotosMapView addAnnotations:self.photoMapAnnotations];
}

#pragma mark - MapKit MKMapViewDelegate Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView * phovoView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"locationPhoto"];
    
    if (phovoView == nil) {
        LocationPhotoPointAnnotation * locationPhotoAnnotation = (LocationPhotoPointAnnotation*) annotation;
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:locationPhotoAnnotation reuseIdentifier:@"locationPhoto"];
        
        NSInteger indexForAnnotation = [self.photoMapAnnotations indexOfObject:annotation];
        
        UIImage * annotationPhoto = [self.locationPhotosCache objectAtIndex:indexForAnnotation];
        
        if ([annotationPhoto isKindOfClass:[UIImage class]]) {
            annotationView.image = annotationPhoto;
            annotationView.layer.cornerRadius = 5.0;
        } else {
            annotationView.image = [UIImage imageNamed:@"gallery"];
            annotationView.layer.cornerRadius = 5.0;
            
            [FlickrAPIManager photoWithID:[locationPhotoAnnotation.photoData valueForKey:@"id"] quality:FlickrAPIManagerPhotoQualityThumbnail success:^(id responseData) {
                self.locationPhotosCache[indexForAnnotation] = [[UIImage alloc] initWithData:responseData];
                annotationView.image = self.locationPhotosCache[indexForAnnotation];
            } failure:^(NSError *error) {
            }];
        }

        return annotationView;
    }
    else {
        phovoView.annotation = annotation;
    }
    
    return phovoView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    LocationPhotoPointAnnotation * locationPhotoPointAnnotation = (LocationPhotoPointAnnotation*) view.annotation;
    NSDictionary * selectedAnnotationPhotoData = locationPhotoPointAnnotation.photoData;
    
    [self showLoadingProgressIndicatorWithMessage:@"Downloading..."];
    
    [FlickrAPIManager photoWithID:[selectedAnnotationPhotoData valueForKey:@"id"] quality:FlickrAPIManagerPhotoQualityLarge success:^(id responseData) {
        [self dismissLoadingProgressIndicator];
        DetailedPhotoViewController * detailedPhotoViewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"DetailedPhotoViewController"];
        detailedPhotoViewController.photoOtherData = selectedAnnotationPhotoData;
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
