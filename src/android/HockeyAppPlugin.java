package org.nypr.cordova.hockeyappplugin;

import net.hockeyapp.android.CrashManager;
import net.hockeyapp.android.UpdateManager;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.util.Log;

public class HockeyAppPlugin extends CordovaPlugin {
	protected static final String LOG_TAG = "HockeyAppPlugin";
	
	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);
	  _checkForCrashes();
	  _checkForUpdates();
		Log.d(LOG_TAG, "HockeyApp Plugin initialized");
	}
	
	@Override
	public void onResume(boolean multitasking) {
		Log.d(LOG_TAG, "HockeyApp Plugin resuming");
	  _checkForUpdates();
		super.onResume(multitasking);
	}

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
    boolean ret=true;
    if(action.equalsIgnoreCase("forcecrash")){
      int i = 1/0;
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
	
	protected void _checkForCrashes() {
		Log.d(LOG_TAG, "HockeyApp Plugin checking for crashes");
		String hockeyAppId="__HOCKEY_APP_KEY__"; // replaced by build script. better to pull from a a config file?
		if(hockeyAppId!=null && !hockeyAppId.equals("") && !hockeyAppId.contains("HOCKEY_APP_KEY")){
			CrashManager.register(cordova.getActivity(), hockeyAppId);
		}
	}

	protected void _checkForUpdates() {
		// Remove this for store builds!
		//__HOCKEY_APP_UPDATE_ACTIVE_START__
		Log.d(LOG_TAG, "HockeyApp Plugin checking for updates");
		String hockeyAppId="__HOCKEY_APP_KEY__";
		if(hockeyAppId!=null && !hockeyAppId.equals("") && !hockeyAppId.contains("HOCKEY_APP_KEY")){		
			UpdateManager.register(cordova.getActivity(), hockeyAppId);
		}
		//__HOCKEY_APP_UPDATE_ACTIVE_END__
	}
}
