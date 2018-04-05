//
//  RNFlurryAdView.h
//  RNFlurryAds
//
//  Created by Mingyu Kang on 3/30/18.
//  Copyright © 2018 SquareTwo. All rights reserved.
//
#import <React/RCTComponent.h>
#import <UIKit/UIKit.h>
#import "FlurryAdNative.h"
#import "FlurryAdNativeDelegate.h"

@class RCTEventDispatcher;

@interface RCTFlurryAdView: UIView <FlurryAdNativeDelegate>
{
    NSString* adSpaceName;
}

@property (nonatomic, copy) RCTBubblingEventBlock onFetchSuccess;
@property (nonatomic, copy) RCTBubblingEventBlock onReceivedClick;
@property (nonatomic, copy) RCTBubblingEventBlock onFetchError;
@property (nonatomic, copy) NSString* adSpaceName;
@property (nonatomic, retain) FlurryAdNative* nativeAd;

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;
+ (UIViewController *) currentViewController;
- (void) refresh;
@end
