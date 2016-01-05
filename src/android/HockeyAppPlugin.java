package org.nypr.cordova.hockeyappplugin;

import net.hockeyapp.android.*;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.lang.RuntimeException;
import java.lang.Runnable;
import java.lang.Thread;

import android.util.Log;

public class HockeyAppPlugin extends CordovaPlugin {
    protected static final String LOG_TAG = "HockeyAppPlugin";

    // replaced by build script. better to pull from a a config file?
    private static final String HOCKEY_APP_ID = "__HOCKEY_APP_ID__";

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        if(isHockeyAppIdValid()) {
            checkForCrashes();
            checkForUpdates();

            Tracking.startUsage(cordova.getActivity());

            Log.d(LOG_TAG, "HockeyApp Plugin initialized");
        }
    }

    @Override
    public void onResume(boolean multitasking) {
        Log.d(LOG_TAG, "HockeyApp Plugin resuming");
        if (isHockeyAppIdValid()) checkForUpdates();
        super.onResume(multitasking);
    }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
    boolean ret=true;
    if(action.equalsIgnoreCase("forcecrash")){
      new Thread(new Runnable() {
        public void run() {
          Calendar c = Calendar.getInstance();
          SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
          throw new RuntimeException("Test crash at " + df.format(c.getTime()));
        }
      }).start();
    }else{
      callbackContext.error(LOG_TAG + " error: invalid action (" + action + ")");
      ret=false;
    }
    return ret;
  }

    @Override
    public void onDestroy() {
        Log.d(LOG_TAG, "HockeyApp Plugin destroying");
        super.onDestroy();
    }

    @Override
    public void onReset() {
        Log.d(LOG_TAG, "HockeyApp Plugin onReset--WebView has navigated to new page or refreshed.");
        super.onReset();
    }

    protected void checkForCrashes() {
        Log.d(LOG_TAG, "HockeyApp Plugin checking for crashes");
        CrashManager.register(cordova.getActivity(), HOCKEY_APP_ID);
    }

    protected void checkForUpdates() {
        Log.d(LOG_TAG, "HockeyApp Plugin checking for updates");
        UpdateManager.register(cordova.getActivity(), HOCKEY_APP_ID);
    }

    protected boolean isHockeyAppIdValid() {
        return HOCKEY_APP_ID!=null && !HOCKEY_APP_ID.equals("") && !HOCKEY_APP_ID.contains("__HOCKEY_APP_ID__");
    }

}
