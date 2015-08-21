package org.nypr.cordova.hockeyappplugin;

import net.hockeyapp.android.CrashManager;
import net.hockeyapp.android.UpdateManager;

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
import java.lang.Exception;

import android.util.Log;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

public class HockeyAppPlugin extends CordovaPlugin {
	protected static final String LOG_TAG = "HockeyAppPlugin";
  protected String hockeyAppId;
  protected Boolean isStore = false;
	
	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);

    try{
      Context context = cordova.getActivity().getApplicationContext();
      ApplicationInfo ai = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
      
      hockeyAppId = ai.metaData.getString("hockey_app_api_key");
      isStore = ai.metaData.getBoolean("hockey_app_is_store");
    } catch (Exception e) {
      Log.e(LOG_TAG, "Unexpected error while reading application info.", e);
		}

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
	
	protected void _checkForCrashes() {
		Log.d(LOG_TAG, "HockeyApp Plugin checking for crashes");
		if(hockeyAppId!=null && !hockeyAppId.equals("") && !hockeyAppId.contains("HOCKEY_APP_KEY")){
			CrashManager.register(cordova.getActivity(), hockeyAppId);
		}
	}

	protected void _checkForUpdates() {
		if(isStore === false){
      Log.d(LOG_TAG, "HockeyApp Plugin checking for updates");
      if(hockeyAppId!=null && !hockeyAppId.equals("") && !hockeyAppId.contains("HOCKEY_APP_KEY")){		
        UpdateManager.register(cordova.getActivity(), hockeyAppId);
      }
		}
	}
}
