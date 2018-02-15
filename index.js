import { NativeModules } from 'react-native';
import FlurryNativeAdsTrackingView from './FlurryNativeAdsTrackingView';

class FlurryAds {
  static initAd(adSpaceName, onClickedCallback, fetchedCallback, errorCallback) {
    NativeModules.RNFlurryAds.initAd(adSpaceName, onClickedCallback,fetchedCallback, errorCallback);
  }

  static fetchAd(adSpaceName) {
    NativeModules.RNFlurryAds.fetchAd(adSpaceName);
  }

  static destroyAd(adSpaceName) {
    NativeModules.FlurryAds.destroyAd(adSpaceName);
  }
}

module.exports = { FlurryAds, FlurryNativeAdsTrackingView };