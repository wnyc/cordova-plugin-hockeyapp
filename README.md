# HockeyApp PhoneGap/Cordova Plugin

### Platform Support

This plugin supports PhoneGap/Cordova apps running on both iOS and Android.

### Version Requirements

This plugin is meant to work with Cordova 3.5.0+ and the latest version of the HockeyApp library.

SDK documentation and integration guides for IOS and Android:  
http://support.hockeyapp.net/kb/client-integration-ios-mac-os-x/hockeyapp-for-ios  
http://support.hockeyapp.net/kb/client-integration-android-other-platforms/hockeyapp-for-android-sdk  

## Installation

#### Automatic Installation using PhoneGap/Cordova CLI (iOS and Android)
1. Make sure you update your projects to Cordova iOS version 3.5.0+ before installing this plugin.

        cordova platform update ios
        cordova platform update android

2. Install this plugin using PhoneGap/Cordova cli:

        cordova plugin add https://github.com/wnyc/cordova-plugin-hockeyapp.git --variable IOS_API_KEY="YOUR_IOS_APP_API_KEY" --variable ANDROID_API_KEY="YOUR_ANDROID_APP_API_KEY" --variable IS_STORE=true

