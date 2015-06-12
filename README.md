# HockeyApp PhoneGap/Cordova Plugin

### Platform Support

This plugin supports PhoneGap/Cordova apps running on both iOS and Android.

### Version Requirements

This plugin is meant to work with Cordova 3.5.0+ and the latest version of the HockeyApp library.

SDK documentation and integration guides for IOS and Android:  
http://support.hockeyapp.net/kb/client-integration-ios-mac-os-x/hockeyapp-for-ios  
http://support.hockeyapp.net/kb/client-integration-android-other-platforms/hockeyapp-for-android-sdk  

TODO - update plugin to latest SDK versions 

## Installation

#### Automatic Installation using PhoneGap/Cordova CLI (iOS and Android)
1. Make sure you update your projects to Cordova iOS version 3.5.0+ before installing this plugin.

        cordova platform update ios
        cordova platform update android

2. Install this plugin using PhoneGap/Cordova cli:

        cordova plugin add https://github.com/kozzztya/cordova-plugin-hockeyapp.git

3. For Android add plugin like this

		cordova plugin add https://github.com/kozzztya/cordova-plugin-hockeyapp.git --variable HOCKEY_APP_ID="__HOCKEY_APP_ID__"

   For iOS, modify HockeyAppPlugin.m, replacing with your configuration setting:
     
        NSString * hockeyAppKey = @"__HOCKEY_APP_KEY__";