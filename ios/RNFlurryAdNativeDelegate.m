//
//  ReactNativeFlurryAdNativeDelegate.m
//  RNFlurryAds
//
//  Created by Mingyu Kang on 2/14/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RNFlurryAdNativeDelegate.h"
#import "FlurryAdNativeDelegate.h"
#import "FlurryAdNativeAsset.h"
#import "FlurryAdNative.h"

@implementation RNFlurryAdNativeDelegate

- (id) initWithAdSpaceName: (NSString *) adSpaceName {
    return self;
}

- (void) adNativeDidFetchAd:(FlurryAdNative*)nativeAd
{
    NSLog(@"Native Ad for Space [%@] Received Ad with [%lu] assets", nativeAd.space, (unsigned long)nativeAd.assetList.count);
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    for (int i = 0 ; i< nativeAd.assetList.count; i++) {
        FlurryAdNativeAsset *asset = (FlurryAdNativeAsset *)nativeAd.assetList[i];
        data[asset.name] = asset.value;
    }
    self._fetchedCallback(@[data]);
}

- (void) adNative:(FlurryAdNative*)nativeAd
          adError:(FlurryAdError)adError
 errorDescription:(NSError*) errorDescription
{
    if (self._errorCallback != nil) {
        self._errorCallback(@[[NSNumber numberWithInt:adError], [NSNumber numberWithInt:errorDescription.code]]);
    }
}

- (void) adNativeDidReceiveClick:(FlurryAdNative*) nativeAd
{
    if (self._onClickCallback != nil) {
        self._onClickCallback(@[[NSNull null]]);
    }

}
@end
