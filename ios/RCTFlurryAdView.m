//
//  RNFlurryAdView.m
//  RNFlurryAds
//
//  Created by Mingyu Kang on 3/30/18.
//  Copyright © 2018 SquareTwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlurryAdNativeDelegate.h"
#import "RCTFlurryAdView.h"
#import <React/RCTEventDispatcher.h>

@implementation RCTFlurryAdView
@synthesize nativeAd;
RCTEventDispatcher *_eventDispatcher;

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

- (FlurryAdNative*) initializeFlurryAd:(NSString*) adSapceName{
    FlurryAdNative *nativeAd = [[FlurryAdNative alloc] initWithSpace:adSpaceName];
    nativeAd.viewControllerForPresentation = RCTFlurryAdView.currentViewController;
    return nativeAd;
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

- (void) refresh {
    [self initAndFetchAd];
}

- (void) initAndFetchAd {
    FlurryAdNative *flurryAd = [self initializeFlurryAd:adSpaceName];
    flurryAd.adDelegate = self;
    self.nativeAd = flurryAd;
    [flurryAd fetchAd];
}

#pragma mark - FlurryAdNativeDelegate delegates
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
    [nativeAd removeTrackingView];
    nativeAd.trackingView = self;
    self.onFetchSuccess(@{
          @"adSpaceName": nativeAd.space,
          @"adData": data,
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
    self.onReceivedClick(@{
          @"adSpaceName": nativeAd.space,
          });
}

@end
