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
#import "Utilities.h"

#define API_KEY @"450b251beda219be0de47e38e5511ea0"
#define APP_SECRET @"d55986dfa5325bbc"
#define API_URL @"https://api.flickr.com/services/rest/"

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
    
    [[FlickrAPIManager sharedManager].request callAPIMethodWithGET:@"flickr.photos.search" arguments:[NSDictionary dictionaryWithObjectsAndKeys:[@(latitude) stringValue], @"lat", [@(longitude) stringValue], @"lon", @"1", @"page", [@(limit) stringValue], @"per_page", @"1", @"nojsoncallback", @"2", @"radius", @"geo", @"extras", nil]];
}

+ (void) photoWithID:(NSString*) photoID quality:(FlickrAPIManagerPhotoQuality) quality success:(void (^) (id responseData)) success failure:(void (^) (NSError * error)) failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_URL parameters:@{ @"method" : @"flickr.photos.getSizes", @"api_key" : API_KEY, @"nojsoncallback" : @"1", @"photo_id" : photoID, @"format" : @"json" } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString * qualityAsString;
        
        switch (quality) {
            case FlickrAPIManagerPhotoQualityThumbnail:
                qualityAsString = @"Thumbnail";
                break;
            case FlickrAPIManagerPhotoQualitySmall:
                qualityAsString = @"Small 320";
                break;
            case FlickrAPIManagerPhotoQualityMedium:
                qualityAsString = @"Medium 640";
                break;
            case FlickrAPIManagerPhotoQualityLarge:
                qualityAsString = @"Large";
                break;
            case FlickrAPIManagerPhotoQualityOriginal:
                qualityAsString = @"Original";
                break;
            default:
                break;
        }
        
        NSString * photoURLString;
        
        for (NSDictionary * photoSize in [[responseObject objectForKey:@"sizes"] objectForKey:@"size"]) {
            if ([[photoSize valueForKey:@"label"] isEqualToString:qualityAsString]) {
                photoURLString = [photoSize valueForKey:@"source"];
                break;
            }
        }
        
        [Utilities downloadDataWithURL:photoURLString success:^(id responseData) {
            if (success) {
                success(responseData);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
