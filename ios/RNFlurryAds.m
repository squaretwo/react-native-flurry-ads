#import "RNFlurryAds.h"
#import "FlurryAdNative.h"
#import <Flurry.h>
#import "RNFlurryAdNativeDelegate.h"

@implementation RNFlurryAds

+ (NSMutableDictionary *)dictionary {
    static NSMutableDictionary *dictionary = nil;
    if (dictionary == nil) {
        dictionary = [NSMutableDictionary dictionary];
    }
    return dictionary;
}

+ (NSMutableDictionary *)listenerdictionary {
    static NSMutableDictionary *listenerdictionary = nil;
    if (listenerdictionary == nil) {
        listenerdictionary = [NSMutableDictionary dictionary];
    }
    return listenerdictionary;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initAd:(NSString *)adSpaceName
                  fetchedCallback:(RCTResponseSenderBlock)fetchedCallback
                  errorCallback:(RCTResponseSenderBlock)errorCallback) {
    FlurryAdNative *nativeAd = nil;
    if (RNFlurryAds.dictionary[adSpaceName] != nil) {
        nativeAd = RNFlurryAds.dictionary[adSpaceName];
    } else {
        nativeAd = [[FlurryAdNative alloc] initWithSpace:adSpaceName];
        RNFlurryAds.dictionary[adSpaceName] = nativeAd;
    }

    RNFlurryAdNativeDelegate *delegate = [[RNFlurryAdNativeDelegate alloc] init];
    delegate._errorCallback = errorCallback;
    delegate._fetchedCallback = fetchedCallback;
    nativeAd.adDelegate = delegate;
    RNFlurryAds.listenerdictionary[adSpaceName] = delegate;
}

RCT_EXPORT_METHOD(setOnClick:(NSString *)adSpaceName
           onClickedCallback:(RCTResponseSenderBlock)callback) {
    if (RNFlurryAds.listenerdictionary[adSpaceName] != nil) {
        RNFlurryAdNativeDelegate *listener = (RNFlurryAdNativeDelegate *)RNFlurryAds.listenerdictionary[adSpaceName];
        listener._onClickCallback = callback;
    }
}

RCT_EXPORT_METHOD(fetchAd:(NSString *)adSpaceName) {
    if (RNFlurryAds.dictionary[adSpaceName] != nil) {
        FlurryAdNative *nativeAd =(FlurryAdNative *)[RNFlurryAds.dictionary objectForKey:adSpaceName];
        [nativeAd fetchAd];
    }
}

RCT_EXPORT_METHOD(destroyAd:(NSString *)adSpaceName) {
    if (RNFlurryAds.dictionary[adSpaceName] != nil) {
        [RNFlurryAds.dictionary removeObjectForKey:adSpaceName];
    }
    if (RNFlurryAds.listenerdictionary[adSpaceName] != nil) {
        [RNFlurryAds.listenerdictionary removeObjectForKey:adSpaceName];
    }
}

@end
