package com.squaretwo.flurryads;

import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.flurry.android.ads.FlurryAdErrorType;
import com.flurry.android.ads.FlurryAdNative;
import com.flurry.android.ads.FlurryAdNativeAsset;
import com.flurry.android.ads.FlurryAdNativeListener;

import java.util.List;

public class RNFlurryAdNativeModule extends ReactContextBaseJavaModule {
    private static final String kLogTag = "RNFlurryAdNativeModule";
    private final ReactApplicationContext reactContext;


    public RNFlurryAdNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @ReactMethod
    public void initAd(String adSpaceName, Callback fetchedCallback, Callback errorCallback) {
        FlurryAdNative flurryAdNative = null;
        if (RNFlurryAdsPackage.adsMap.containsKey(adSpaceName)) {
            flurryAdNative = RNFlurryAdsPackage.adsMap.get(adSpaceName);
        } else {
            flurryAdNative = new FlurryAdNative(this.reactContext, adSpaceName);
            RNFlurryAdsPackage.adsMap.put(adSpaceName, flurryAdNative);
        }
        ReactNativeFlurryAdNativeListener listener = new ReactNativeFlurryAdNativeListener();
        listener.fetchedCallback = fetchedCallback;
        listener.errorCallback = errorCallback;
        listener.onClickedCallback = new OnClickListener() {
            @Override
            public void onClick(String adSpaceName) {
                sendEvent(reactContext, adSpaceName);
            }
        };
        RNFlurryAdsPackage.listenersMap.put(adSpaceName, listener);
        flurryAdNative.setListener(listener);
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
            RNFlurryAdsPackage.adsMap.remove(adSpaceName);
        }
        if (RNFlurryAdsPackage.listenersMap.containsKey(adSpaceName)) {
            RNFlurryAdsPackage.listenersMap.get(adSpaceName).onClickedCallback = null;
            RNFlurryAdsPackage.listenersMap.remove(adSpaceName);
        }
    }

    private void sendEvent(ReactContext reactContext,
                           String adSpaceName) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("EventClickAd", adSpaceName);
    }


    @Override
    public String getName() {
        return "RNFlurryAds";
    }

    interface OnClickListener {
        void onClick(String adSpaceName);
    }

    class ReactNativeFlurryAdNativeListener implements FlurryAdNativeListener {

        public Callback fetchedCallback = null;
        public OnClickListener onClickedCallback = null;
        public Callback errorCallback = null;

        public ReactNativeFlurryAdNativeListener() {

        }

        @Override
        public void onFetched(FlurryAdNative flurryAdNative) {
            Log.i(kLogTag, "onFetched ");
            WritableMap data = Arguments.createMap();
            List<FlurryAdNativeAsset> list = flurryAdNative.getAssetList();
            for (int i = 0; i < list.size(); i++) {
                data.putString(list.get(i).getName(),list.get(i).getValue());
            }
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
            onClickedCallback.onClick(flurryAdNative.getAdSpace());
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