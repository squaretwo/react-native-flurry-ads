import { NativeEventEmitter, NativeModules } from 'react-native';
import FlurryNativeAdsTrackingView from './FlurryNativeAdsTrackingView';

class FlurryAds {
  static clickEventCallbacks = {};

  static initAd(adSpaceName, fetchedCallback, errorCallback) {
    NativeModules.RNFlurryAds.initAd(adSpaceName,fetchedCallback, errorCallback);
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
  }
}

const flurryAdEmitter = new NativeEventEmitter(NativeModules.RNFlurryAds);

const subscription = flurryAdEmitter.addListener(
  'EventClickAd',
  (adSpaceName) => {
      if(FlurryAds.clickEventCallbacks[adSpaceName]) {
        FlurryAds.clickEventCallbacks[adSpaceName]();
      }
  }
);

module.exports = { FlurryAds, FlurryNativeAdsTrackingView };