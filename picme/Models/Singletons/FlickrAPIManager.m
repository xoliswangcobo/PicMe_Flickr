//
//  FlickrAPIManager.m
//  picme
//
//  Created by Xoliswa Ngcobo on 2017/02/23.
//  Copyright © 2017 XoliswaNgcobo. All rights reserved.
//

#import "FlickrAPIManager.h"
#import <ObjectiveFlickr/ObjectiveFlickr.h>

#define API_KEY @"450b251beda219be0de47e38e5511ea0"
#define APP_SECRET @"d55986dfa5325bbc"

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

@end
