//
//  FlickrAPIManager.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/23.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "FlickrAPIManager.h"
#import <ObjectiveFlickr/ObjectiveFlickr.h>
#import "AFNetworking.h"

#define API_KEY @"450b251beda219be0de47e38e5511ea0"
#define APP_SECRET @"d55986dfa5325bbc"
#define PLACES_API_KEY @"AIzaSyBYPoge1PLoobQFhVDfL4k5HulfXBrOnMM"
#define PLACES_API_NEARBYSEARCH_URL @"https://maps.googleapis.com/maps/api/place/nearbysearch/json"

#pragma mark - FlickrAPIManager

static FlickrAPIManager * sharedManager_;

@interface FlickrAPIManager() <OFFlickrAPIRequestDelegate>
    @property (strong, nonatomic) OFFlickrAPIContext *context;
    @property (strong, nonatomic) OFFlickrAPIRequest *request;

    // Block / callbacks
    @property (nonatomic, copy) void (^apiSuccessBlock) (NSDictionary * responseDictionary);
    @property (nonatomic, copy) void (^apiFailureBlock) (NSError * error);
    @property (nonatomic, copy) void (^apiProgressBlock) (NSUInteger inSentBytes);
@end

@implementation FlickrAPIManager

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.context = [[OFFlickrAPIContext alloc] initWithAPIKey:API_KEY sharedSecret:APP_SECRET];
        self.request = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.context];
        self.request.delegate = self;
    }
    
    return self;
}

+ (FlickrAPIManager*) sharedManager {
    if (sharedManager_ == nil) {
        sharedManager_ = [FlickrAPIManager new];
    }
    
    return sharedManager_;
}

+ (void)resetManager {
    sharedManager_ = nil;
}


#pragma mark - OFFlickrAPIRequestDelegate

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary {
    if (self.apiSuccessBlock) {
        self.apiSuccessBlock(inResponseDictionary);
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError {
    if (self.apiFailureBlock) {
        self.apiFailureBlock(inError);
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes {
    if (self.apiProgressBlock) {
        self.apiProgressBlock(inSentBytes);
    }
}


#pragma mark - OFFlickrAPIMethods

+ (void) photosForLocationWithLatitude:(float) latitude  longitude:(float) longitude resultLimit:(NSInteger) limit success:(void (^) (NSDictionary * responseDictionary)) success failure:(void (^) (NSError * error)) failure {
    [FlickrAPIManager sharedManager].apiSuccessBlock = success;
    [FlickrAPIManager sharedManager].apiFailureBlock = failure;
    
    [[FlickrAPIManager sharedManager].request callAPIMethodWithGET:@"flickr.photos.search" arguments:[NSDictionary dictionaryWithObjectsAndKeys:[@(latitude) stringValue], @"lat", [@(longitude) stringValue], @"lon", @"1", @"page", [@(limit) stringValue], @"per_page", @"1", @"nojsoncallback", @"2", @"radius", nil]];
}


#pragma mark - AFNetworking/Google Utilities

+ (void) downloadDataWithURL:(NSString*) dataURLString success:(void (^) (id responseData)) success failure:(void (^) (NSError * error)) failure {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:dataURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if(failure) {
                failure(error);
            }
        } else {
            NSLog(@"%@ %@", response, responseObject);
            if (success) {
                success(responseObject);
            }
        }
    }];
    
    [dataTask resume];
}

- (void) placesNearbyLatitude:(float) latitude longitude:(float) longitude success:(void (^) (NSDictionary * responseDictionary)) success failure:(void (^) (NSError * error)) failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:PLACES_API_NEARBYSEARCH_URL parameters:@{ @"key" : PLACES_API_KEY, @"location" : [NSString stringWithFormat:@"%f,%f", latitude, longitude], @"type" : @"shopping_mall", @"radius" : @"5000" } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if(failure) {
            failure(error);
        }
    }];
}

@end
