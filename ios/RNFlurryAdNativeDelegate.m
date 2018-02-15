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

- (id) initWithAdSpaceName: (NSString *) adSpaceName
        andOnClickCallback: (RCTResponseSenderBlock)onClickCallback
        andFetchedCallback: (RCTResponseSenderBlock)fetchedCallback
          andErrorCallback: (RCTResponseSenderBlock)errorCallback {
    if ( self = [super init] ) {
        self._onClickCallback = onClickCallback;
        self._fetchedCallback = fetchedCallback;
        self._errorCallback = errorCallback;
    }
    return self;
}

- (void) adNativeDidFetchAd:(FlurryAdNative*)nativeAd
{
    NSLog(@"Native Ad for Space [%@] Received Ad with [%lu] assets", nativeAd.space, (unsigned long)nativeAd.assetList.count);
    
}

- (void) adNative:(FlurryAdNative*)nativeAd
          adError:(FlurryAdError)adError
 errorDescription:(NSError*) errorDescription
{
    self._errorCallback(@[[NSNull null], [NSNumber numberWithInt:adError], [NSNumber numberWithInt:errorDescription.code]]);
}

- (void) adNativeDidReceiveClick:(FlurryAdNative*) nativeAd
{
    self._onClickCallback(@[[NSNull null]]);
}
@end
