#import "RNFlurryAds.h"
#import "FlurryAdNative.h"
#import <Flurry.h>
#import "RNFlurryAdNativeDelegate.h"

@implementation RNFlurryAds
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initAd:(NSString *)adSpaceName
                  fetchedCallback:(RCTResponseSenderBlock)fetchedCallback
                  errorCallback:(RCTResponseSenderBlock)errorCallback) {
    if (dictionary == nil) {
        dictionary = [NSMutableDictionary dictionary];
    }
    if (listenerdictionary == nil) {
        listenerdictionary = [NSMutableDictionary dictionary];
    }
    FlurryAdNative *nativeAd = nil;
    if (dictionary[adSpaceName] != nil) {
        nativeAd = dictionary[adSpaceName];
    } else {
        nativeAd = [[FlurryAdNative alloc] initWithSpace:adSpaceName];
        dictionary[adSpaceName] = nativeAd;
    }

    RNFlurryAdNativeDelegate *delegate = [[RNFlurryAdNativeDelegate alloc] init];
    delegate._errorCallback = errorCallback;
    delegate._fetchedCallback = fetchedCallback;
    nativeAd.adDelegate = delegate;
    listenerdictionary[adSpaceName] = delegate;
}

RCT_EXPORT_METHOD(setOnClick:(NSString *)adSpaceName
           onClickedCallback:(RCTResponseSenderBlock)callback) {
    if (listenerdictionary[adSpaceName] != nil) {
        RNFlurryAdNativeDelegate *listener = (RNFlurryAdNativeDelegate *)listenerdictionary[adSpaceName];
        listener._onClickCallback = callback;
    }
}

RCT_EXPORT_METHOD(fetchAd:(NSString *)adSpaceName) {
    if (dictionary[adSpaceName] != nil) {
        FlurryAdNative *nativeAd =(FlurryAdNative *)[dictionary objectForKey:adSpaceName];
        [nativeAd fetchAd];
    }
}

RCT_EXPORT_METHOD(destroyAd:(NSString *)adSpaceName) {
    if (dictionary[adSpaceName] != nil) {
        [dictionary removeObjectForKey:adSpaceName];
    }
    if (listenerdictionary[adSpaceName] != nil) {
        [listenerdictionary removeObjectForKey:adSpaceName];
    }
}

@end
