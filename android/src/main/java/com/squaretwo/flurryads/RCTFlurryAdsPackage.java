
package com.squaretwo.flurryads;

import android.util.Log;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.flurry.android.ads.FlurryAdNative;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

public class RCTFlurryAdsPackage implements ReactPackage {

    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Arrays.<ViewManager>asList(new RCTFlurryAdViewManager());
    }
}
