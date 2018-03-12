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

+ (UIViewController *) currentViewController {
    UIViewController *topVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while((topVC.presentedViewController) != nil){
        topVC = topVC.presentedViewController;
    }
    return topVC;

}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(initAd:(NSString *)adSpaceName) {
    FlurryAdNative *nativeAd = [[FlurryAdNative alloc] initWithSpace:adSpaceName];
    nativeAd.viewControllerForPresentation = RNFlurryAds.currentViewController;

    RNFlurryAds.dictionary[adSpaceName] = nativeAd;

    RNFlurryAdNativeDelegate *delegate = [[RNFlurryAdNativeDelegate alloc] init];
    delegate._fetchedCallback = ^(NSString* space, NSMutableDictionary* adData){
        [self sendEventWithName:@"EventFetch" body:@{@"adSpaceName": space, @"adData": adData}];
    };
    delegate._errorCallback = ^(NSString* space, NSNumber* errorType, NSNumber* errorCode){
        [self sendEventWithName:@"EventError" body:@{@"adSpaceName": space, @"errorType": errorType, @"errorCode": errorCode}];
    };
    delegate._onClickCallback = ^(NSString* space){
        [self sendEventWithName:@"EventClickAd" body:space];
    };
    nativeAd.adDelegate = delegate;
    RNFlurryAds.listenerdictionary[adSpaceName] = delegate;
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

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"EventClickAd",@"EventError",@"EventFetch"];
}
@end
