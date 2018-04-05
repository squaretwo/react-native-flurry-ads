package com.squaretwo.flurryads;

import android.content.Context;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.flurry.android.ads.FlurryAdErrorType;
import com.flurry.android.ads.FlurryAdNative;
import com.flurry.android.ads.FlurryAdNativeAsset;
import com.flurry.android.ads.FlurryAdNativeListener;

import java.util.List;

/**
 * Created by mingyukang on 4/3/18.
 */

public class RCTFlurryAdView extends LinearLayout {

    public enum Events {
        EVENT_FETCH("onFetchSuccess"),
        EVENT_RECEIVED_CLICK("onReceivedClick"),
        EVENT_FETCH_ERROR("onFetchError");

        private final String mName;

        Events(final String name) {
            mName = name;
        }

        @Override
        public String toString() {
            return mName;
        }
    }

    private static final String kLogTag = "RCTFlurryAdView";
    private final ThemedReactContext themedReactContext;
    private RCTEventEmitter mEventEmitter;
    private FlurryAdNative flurryAd = null;

    String adSpaceName = null;

    public RCTFlurryAdView(ThemedReactContext themedReactContext) {
        super(themedReactContext);
        this.themedReactContext = themedReactContext;
        mEventEmitter = themedReactContext.getJSModule(RCTEventEmitter.class);
    }

    public void setAdSpaceName(String adSpaceName) {
        if (this.adSpaceName != null) {
            return;
        }
        this.adSpaceName = adSpaceName;
        initAndFetchAd();
    }

    public void refresh() {
        initAndFetchAd();
    }

    private void initAndFetchAd() {
        FlurryAdNative flurryAd = initializeFlurryAd(adSpaceName);
        this.flurryAd = flurryAd;
        flurryAd.fetchAd();
    }

    private FlurryAdNative initializeFlurryAd(String adSpaceName) {
        FlurryAdNative flurryAdNative = new FlurryAdNative(this.themedReactContext, adSpaceName);
        RCTFlurryAdView.ReactNativeFlurryAdNativeListener listener = new RCTFlurryAdView.ReactNativeFlurryAdNativeListener();
        flurryAdNative.setListener(listener);
        return flurryAdNative;
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (this.flurryAd != null) {
            this.flurryAd.destroy();
            this.flurryAd = null;
        }
    }

    class ReactNativeFlurryAdNativeListener implements FlurryAdNativeListener {

        @Override
        public void onFetched(FlurryAdNative flurryAdNative) {
            Log.i(kLogTag, "onFetched ");
            WritableMap data = Arguments.createMap();
            List<FlurryAdNativeAsset> list = flurryAdNative.getAssetList();
            for (int i = 0; i < list.size(); i++) {
                data.putString(list.get(i).getName(),list.get(i).getValue());
            }

            WritableMap event = Arguments.createMap();
            event.putString("adSpaceName", adSpaceName);
            event.putMap("adData", data);
            flurryAdNative.setTrackingView(RCTFlurryAdView.this);
            mEventEmitter.receiveEvent(getId(), Events.EVENT_FETCH.toString(), event);
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
            WritableMap event = Arguments.createMap();
            event.putString("adSpaceName", adSpaceName);
            mEventEmitter.receiveEvent(getId(), Events.EVENT_RECEIVED_CLICK.toString(), event);
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
                int errorType = flurryAdErrorType.ordinal();

                WritableMap event = Arguments.createMap();
                event.putString("adSpaceName", adSpaceName);
                event.putInt("errorType", errorType);
                event.putInt("errorCode", errorCode);

                mEventEmitter.receiveEvent(getId(), Events.EVENT_FETCH_ERROR.toString(), event);
            }
        }
    }
}
