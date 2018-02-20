//
//  ReactNativeFlurryAdNativeDelegate.h
//  RNFlurryAds
//
//  Created by Mingyu Kang on 2/14/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "FlurryAdNativeDelegate.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>

@interface RNFlurryAdNativeDelegate : NSObject <FlurryAdNativeDelegate>

@property (nonatomic, copy) void (^_onClickCallback)(NSString*);
@property RCTResponseSenderBlock _fetchedCallback;
@property RCTResponseSenderBlock _errorCallback;

- (id) initWithAdSpaceName: (NSString *) adSpaceName;
@end



