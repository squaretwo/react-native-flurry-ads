import { NativeEventEmitter, NativeModules } from 'react-native';
import FlurryNativeAdsTrackingView from './FlurryNativeAdsTrackingView';

class FlurryAds {
  static clickEventCallbacks = {};
  static errorCallbacks = {};

  static initAd(adSpaceName, fetchedCallback, errorCallback) {
    NativeModules.RNFlurryAds.initAd(adSpaceName, fetchedCallback);
    FlurryAds.errorCallbacks[adSpaceName] = errorCallback;
  }

  static setOnClick(adSpaceName, onClick) {
    FlurryAds.clickEventCallbacks[adSpaceName] = onClick;
  }

  static fetchAd(adSpaceName) {
    NativeModules.RNFlurryAds.fetchAd(adSpaceName);
  }

  static destroyAd(adSpaceName) {
    NativeModules.FlurryAds.destroyAd(adSpaceName);
    FlurryAds.clickEventCallbacks[adSpaceName] = undefined;
    FlurryAds.errorCallbacks[adSpaceName] = undefined;
  }
}

const flurryAdEmitter = new NativeEventEmitter(NativeModules.RNFlurryAds);

flurryAdEmitter.addListener(
  'EventClickAd',
  (adSpaceName) => {
      if(FlurryAds.clickEventCallbacks[adSpaceName]) {
        FlurryAds.clickEventCallbacks[adSpaceName]();
      }
  }
);

flurryAdEmitter.addListener(
  'EventError',
  (params) => {
    if(FlurryAds.errorCallbacks[params.adSpaceName]) {
      FlurryAds.errorCallbacks[params.adSpaceName](params.errorType, params.errorCode);
    }
  }
);

module.exports = { FlurryAds, FlurryNativeAdsTrackingView };