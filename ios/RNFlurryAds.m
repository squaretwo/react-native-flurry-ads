#import "RNFlurryAds.h"
#import "FlurryAdNative.h"
#import <Flurry.h>
#import "RNFlurryAdNativeDelegate.h"

@implementation RNFlurryAds
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initAd:(NSString *)adSpaceName
                  callbacks:(NSArray *)callbacks) {
    RCTResponseSenderBlock onClickedCallback = (RCTResponseSenderBlock)callbacks[0];
    RCTResponseSenderBlock fetchedCallback = (RCTResponseSenderBlock)callbacks[1];
    RCTResponseSenderBlock errorCallback = (RCTResponseSenderBlock)callbacks[2];
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
    
    RNFlurryAdNativeDelegate *delegate = [[RNFlurryAdNativeDelegate alloc] initWithAdSpaceName:adSpaceName andOnClickCallback:onClickedCallback andFetchedCallback:fetchedCallback andErrorCallback:errorCallback];
    nativeAd.adDelegate = delegate;
    listenerdictionary[adSpaceName] = delegate;
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

