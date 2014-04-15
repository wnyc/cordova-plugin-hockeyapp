//
//  HockeyAppPlugin.h
//  NYPRNative
//
//  Created by Bradford Kammin on 4/1/14.
//
//

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>

@interface HockeyAppPlugin : CDVPlugin <BITHockeyManagerDelegate, BITUpdateManagerDelegate,BITCrashManagerDelegate>

@end
