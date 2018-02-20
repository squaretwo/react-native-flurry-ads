//
//  RNTFlurryNativeAdsTrackingViewManager.m
//  RNFlurryAds
//
//  Created by Mingyu Kang on 2/19/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <React/RCTViewManager.h>
#import "RNFlurryAds.h"
#import <FlurryAdNative.h>

@interface RCTFlurryNativeAdsTrackingViewManager : RCTViewManager
@end

@implementation RCTFlurryNativeAdsTrackingViewManager

RCT_EXPORT_MODULE()

RCT_CUSTOM_VIEW_PROPERTY(adSpaceName, NSString*, UIView)
{
    FlurryAdNative *nativeAd =(FlurryAdNative *)[dictionary objectForKey:json];
    [nativeAd removeTrackingView];
    nativeAd.trackingView = view;
}

- (UIView *)view
{
    return [[UIView alloc] init];
}
@end
