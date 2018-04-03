//
//  RNTFlurryNativeAdsTrackingViewManager.m
//  RNFlurryAds
//
//  Created by Mingyu Kang on 2/19/18.
//  Copyright © 2018 SquareTwo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <React/RCTViewManager.h>
#import "RCTFlurryAdViewManager.h"
#import "RCTFlurryAdView.h"

@implementation RCTFlurryAdViewManager{
    RCTFlurryAdView* _RCTFlurryAdView;
}

@synthesize bridge = _bridge;

- (UIView *)view
{
    _RCTFlurryAdView = [[RCTFlurryAdView alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
    return _RCTFlurryAdView;
}

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(onFetchSuccess, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onReceviedClick, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFetchError, RCTBubblingEventBlock)
RCT_EXPORT_METHOD(refresh) {
    [_RCTFlurryAdView initAndFetchAd];
}

RCT_CUSTOM_VIEW_PROPERTY(adSpaceName, NSString*, RCTFlurryAdView)
{
    [view setAdSpaceName:json];
}
@end
