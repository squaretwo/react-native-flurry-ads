package com.squaretwo.flurryads;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.flurry.android.ads.FlurryAdErrorType;
import com.flurry.android.ads.FlurryAdNative;
import com.flurry.android.ads.FlurryAdNativeListener;

public class RNFlurryAdNativeModule extends ReactContextBaseJavaModule {
  private static final String kLogTag = "RNFlurryAdNativeModule";
  private final ReactApplicationContext reactContext;


  public RNFlurryAdNativeModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @ReactMethod
  public void initAd(String adSpaceName, Callback onClickedCallback, Callback fetchedCallback, Callback errorCallback) {
    FlurryAdNative flurryAdNative = null;
    if (RNFlurryAdsPackage.adsMap.containsKey(adSpaceName)) {
      flurryAdNative = RNFlurryAdsPackage.adsMap.get(adSpaceName);
    } else {
      flurryAdNative = new FlurryAdNative(this.reactContext, adSpaceName);
      RNFlurryAdsPackage.adsMap.put(adSpaceName, flurryAdNative);
    }
    flurryAdNative.setListener(new ReactNativeFlurryAdNativeListener(fetchedCallback, onClickedCallback, errorCallback));
  }

  @ReactMethod
  public void fetchAd(String adSpaceName) {
    if (RNFlurryAdsPackage.adsMap.containsKey(adSpaceName)) {
      FlurryAdNative flurryAdNative = RNFlurryAdsPackage.adsMap.get(adSpaceName);
      flurryAdNative.fetchAd();
    }
  }

  @ReactMethod
  public void destroyAd(String adSpaceName) {
    if (RNFlurryAdsPackage.adsMap.containsKey(adSpaceName)) {
      FlurryAdNative flurryAdNative = RNFlurryAdsPackage.adsMap.get(adSpaceName);
      flurryAdNative.destroy();
    }
  }


  @Override
  public String getName() {
    return "RNFlurryAds";
  }

  class ReactNativeFlurryAdNativeListener implements FlurryAdNativeListener {

    private Callback fetchedCallback = null;
    private Callback onClickedCallback = null;
    private Callback errorCallback = null;

    public ReactNativeFlurryAdNativeListener(Callback fetchedCallback, Callback onClickedCallback, Callback errorCallback) {
      this.fetchedCallback = fetchedCallback;
      this.onClickedCallback = onClickedCallback;
    }

    @Override
    public void onFetched(FlurryAdNative flurryAdNative) {
      Log.i(kLogTag, "onFetched ");
      WritableMap data = Arguments.createMap();
      data.putString("headline", flurryAdNative.getAsset("headline").getValue());
      data.putString("summary", flurryAdNative.getAsset("summary").getValue());
      data.putString("source", flurryAdNative.getAsset("source").getValue());
      data.putString("secHqBrandingLogo", flurryAdNative.getAsset("secHqBrandingLogo").getValue());
      data.putString("secHqImage", flurryAdNative.getAsset("secHqImage").getValue());


      fetchedCallback.invoke(data);
    }

    @Override
    public void onShowFullscreen(FlurryAdNative flurryAdNative) {
      Log.i(kLogTag, "onShowFullscreen ");
    }

    @Override
    public void onCloseFullscreen(FlurryAdNative flurryAdNative) {
      Log.i(kLogTag, "onCloseFullscreen ");
    }

    @Override
    public void onAppExit(FlurryAdNative flurryAdNative) {
      Log.i(kLogTag, "onAppExit ");
    }

    @Override
    public void onClicked(FlurryAdNative flurryAdNative) {
      Log.i(kLogTag, "onClicked ");
      onClickedCallback.invoke();
    }

    @Override
    public void onImpressionLogged(FlurryAdNative flurryAdNative) {
      Log.i(kLogTag, "onImpressionLogged ");
    }

    @Override
    public void onExpanded(FlurryAdNative flurryAdNative) {
      Log.i(kLogTag, "onExpanded ");
    }

    @Override
    public void onCollapsed(FlurryAdNative flurryAdNative) {
      Log.i(kLogTag, "onCollapsed ");
    }

    @Override
    public void onError(FlurryAdNative flurryAdNative, FlurryAdErrorType flurryAdErrorType, int errorCode) {
      if (flurryAdErrorType.equals(FlurryAdErrorType.FETCH)) {
        Log.i(kLogTag, "onFetchFailed " + errorCode);
        errorCallback.invoke(flurryAdErrorType, errorCode);
      }
    }
  }
}