//
//  HockeyAppPlugin.h
//

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>

@interface HockeyAppPlugin : CDVPlugin <BITHockeyManagerDelegate, BITUpdateManagerDelegate,BITCrashManagerDelegate>

- (void)forcecrash:(CDVInvokedUrlCommand*)command;

@end
