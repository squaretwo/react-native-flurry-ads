package com.squaretwo.flurryads;

import android.util.Log;
import android.view.View;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.flurry.android.ads.FlurryAdNative;

public class RNFlurryAdNativeTrackingViewManager extends SimpleViewManager<View> {
    private static final String kLogTag = "RCTFlurryTrackingView";
    private static final String REACT_CLASS = "RCTFlurryNativeAdsTrackingView";

    @ReactProp(name = "adSpaceName")
    public void setTrackingView(View view, String adSpaceName) {
        if (RNFlurryAdsPackage.adsMap.containsKey(adSpaceName)) {
            FlurryAdNative flurryAdNative = RNFlurryAdsPackage.adsMap.get(adSpaceName);
            flurryAdNative.removeTrackingView();
            flurryAdNative.setTrackingView(view);
        } else {
            Log.i(kLogTag, "onAppExit ");
        }
    }

    @Override
    public View createViewInstance(ThemedReactContext context) {
        return new View(context);
    }
    
    @Override
    public String getName() {
        return REACT_CLASS;
    }
}
