//
//  RNTFlurryNativeAdsTrackingViewManager.m
//  RNFlurryAds
//
//  Created by Mingyu Kang on 2/19/18.
//  Copyright © 2018 SquareTwo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <React/RCTViewManager.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
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
RCT_EXPORT_VIEW_PROPERTY(onReceivedClick, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFetchError, RCTBubblingEventBlock)
RCT_EXPORT_METHOD(refresh:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RCTFlurryAdView *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[RCTFlurryAdView class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting RCTFlurryAdView, got: %@", view);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [view refresh];
        });
    }];
}

RCT_CUSTOM_VIEW_PROPERTY(adSpaceName, NSString*, RCTFlurryAdView)
{
    [view setAdSpaceName:json];
}
@end
