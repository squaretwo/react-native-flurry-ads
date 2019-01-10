package com.squaretwo.flurryads;

import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.flurry.android.ads.FlurryAdNative;

import java.util.Map;

import javax.annotation.Nullable;

public class RCTFlurryAdViewManager extends ViewGroupManager<RCTFlurryAdView> {
    private static final String kLogTag = "RCTFlurryAdView";
    private static final String REACT_CLASS = "RCTFlurryAdView";

    public static final int COMMAND_REFRESH = 1;

    @ReactProp(name = "adSpaceName")
    public void setTrackingView(RCTFlurryAdView view, String adSpaceName) {
        view.setAdSpaceName(adSpaceName);
    }

    @Override
    public RCTFlurryAdView createViewInstance(ThemedReactContext context) {
        return new RCTFlurryAdView(context);
    }

    @Override
    public void receiveCommand(RCTFlurryAdView view, int commandId, @Nullable ReadableArray args) {
        switch (commandId) {
            case COMMAND_REFRESH: {
                view.refresh();
                return;
            }
            default:
                throw new IllegalArgumentException(String.format(
                        "Unsupported command %d received by %s.",
                        commandId,
                        getClass().getSimpleName()));
        }
    }

    @Override
    public Map<String,Integer> getCommandsMap() {
        Log.d("React"," View manager getCommandsMap:");
        return MapBuilder.of("refresh",COMMAND_REFRESH);
    }



    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.builder()
                .put("onFetchError", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onFetchError")))
                .put("onFetchSuccess", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onFetchSuccess")))
                .put("onReceivedClick", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onReceivedClick")))
                .build();
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }
}

