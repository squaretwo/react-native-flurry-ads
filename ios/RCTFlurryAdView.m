//
//  RNFlurryAdView.m
//  RNFlurryAds
//
//  Created by Mingyu Kang on 3/30/18.
//  Copyright © 2018 SquareTwo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCTFlurryAdView.h"
#import <React/RCTEventDispatcher.h>

@implementation RCTFlurryAdView
RCTEventDispatcher *_eventDispatcher;
@synthesize nativeAd = _nativeAd;

+ (UIViewController *) currentViewController {
    UIViewController *topVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while((topVC.presentedViewController) != nil){
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
    if ((self = [super init])) {
        _eventDispatcher = eventDispatcher;
    }
    return self;
}

- (void) initFlurryAd {
    if (self.nativeAd != nil) {
        return;
    }
    self.nativeAd = [[FlurryAdNative alloc] initWithSpace:adSpaceName];
    self.nativeAd.adDelegate = self;
    self.nativeAd.viewControllerForPresentation = RCTFlurryAdView.currentViewController;
    self.nativeAd.trackingView = self;
}

- (void) setAdSpaceName:(NSString *)newAdSpaceName {
    if (adSpaceName != nil) {
        return;
    }
    adSpaceName = newAdSpaceName;
    [self initAndFetchAd];
}

- (NSString*) adSpaceName {
    return adSpaceName;
}


- (void) initAndFetchAd {
    self.nativeAd = nil;
    [self initFlurryAd];
    [self.nativeAd fetchAd];
}

- (void) adNativeDidFetchAd:(FlurryAdNative*) nativeAd
{
    NSLog(@"Native Ad for Space [%@] Received Ad with [%lu] assets", nativeAd.space, (unsigned long)nativeAd.assetList.count);
    if (!self.onFetchSuccess) {
        return;
    }
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    for (int i = 0 ; i < nativeAd.assetList.count; i++) {
        FlurryAdNativeAsset *asset = (FlurryAdNativeAsset *)nativeAd.assetList[i];
        data[asset.name] = asset.value;
    }
    self.onFetchSuccess(@{
          @"adSpaceName": nativeAd.space,
          @"data": data,
      });
}

- (void) adNative:(FlurryAdNative*)nativeAd
          adError:(FlurryAdError)adError
 errorDescription:(NSError*) errorDescription
{
    self.onFetchError(@{
          @"adSpaceName": nativeAd.space,
          @"errorType": [NSNumber numberWithInt:adError],
          @"errorCode": [NSNumber numberWithInt:errorDescription.code]
          });
}

- (void) adNativeDidReceiveClick:(FlurryAdNative*) nativeAd
{
    self.onReceviedClick(@{
          @"adSpaceName": nativeAd.space,
          });
}

- (void)removeFromSuperview
{
    self.nativeAd = nil;
    [super removeFromSuperview];
}

@end
