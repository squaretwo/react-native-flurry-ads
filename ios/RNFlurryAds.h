#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RNFlurryAds : RCTEventEmitter <RCTBridgeModule>
+ (NSMutableDictionary *) dictionary;
+ (NSMutableDictionary *) listenerdictionary;
+ (UIViewController *) currentViewController;
@end


