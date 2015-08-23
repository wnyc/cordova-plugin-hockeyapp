//
//  HockeyAppPlugin.m
//

#import <HockeySDK/HockeySDK.h>

#import "HockeyAppPlugin.h"
#import "DDFileLogger.h"

extern int ddLogLevel;

static NSString *const kHockeyAppPluginAppReachedTerminateEventKey = @"AppReachedTerminateEvent";

@interface HockeyAppPlugin ()

@property (nonatomic) DDFileLogger *fileLogger;

@end

@implementation HockeyAppPlugin

#pragma mark Initialization

- (void)pluginInitialize {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString * hockeyAppKey = [infoPlist objectForKey:@"HockeyAppApiKey"];

    if( hockeyAppKey!=nil && [hockeyAppKey isEqualToString:@""]==NO && [hockeyAppKey rangeOfString:@"HOCKEY_APP_KEY"].location == NSNotFound ){

        // initialize before HockeySDK, so the delegate can access the file logger
        self.fileLogger = [[DDFileLogger alloc] init];
        self.fileLogger.maximumFileSize = (1024 * 64); // 64 KByte
        self.fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
        [self.fileLogger rollLogFileWithCompletionBlock:nil];
        [DDLog addLogger:self.fileLogger];

        // hack to prevent sending crash report for crashes that occur when app is shutting down
        // reference for deleting crash report file:
        // http://support.hockeyapp.net/discussions/problems/33370-is-there-a-way-to-manually-send-the-most-recent-crash-report-after-changing-the-crash-reporting-status
        BOOL appReachedTerminateEvent = [[[NSUserDefaults standardUserDefaults] valueForKey:kHockeyAppPluginAppReachedTerminateEventKey] boolValue];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHockeyAppPluginAppReachedTerminateEventKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if (appReachedTerminateEvent) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cacheDir = [paths objectAtIndex: 0];
            NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
            NSString *filePath = [cacheDir stringByAppendingPathComponent:@"com.plausiblelabs.crashreporter.data"];
            filePath = [filePath stringByAppendingPathComponent:bundleIdentifier];
            filePath = [filePath stringByAppendingPathComponent:@"live_report.plcrash"];
            BOOL fileExists = [fileManager fileExistsAtPath:filePath];
            NSError *error = nil;
            if (fileExists) {
                if (![fileManager removeItemAtPath:filePath error:&error]) {
                    DDLogInfo(@"Could not delete crash report file:  %@ (%@)", error, filePath);
                }
            }
        }
        
        [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:hockeyAppKey
                                                             liveIdentifier:hockeyAppKey
                                                                   delegate:self];
        
        [[BITHockeyManager sharedHockeyManager] startManager];
        [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    }
    
    DDLogInfo(@"HockeyApp Plugin initialized");
}

#pragma mark Shutdown methods

- (void)onAppTerminate {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHockeyAppPluginAppReachedTerminateEventKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Plugin methods

- (void)forcecrash:(CDVInvokedUrlCommand *)command {
  DDLogWarn(@"HockeyApp Plugin crashing the app!");
  __builtin_trap();
}

#pragma mark Logging methods

// get the log content with a maximum byte size
- (NSString *) getLogFilesContentWithMaxSize:(NSInteger)maxSize {
    NSMutableString *description = [NSMutableString string];
    
    NSArray *sortedLogFileInfos = [[_fileLogger logFileManager] sortedLogFileInfos];
    NSInteger count = [sortedLogFileInfos count];
    
    // we start from the last one
    for (NSInteger index = count - 1; index >= 0; index--) {
        DDLogFileInfo *logFileInfo = [sortedLogFileInfos objectAtIndex:index];
        
        NSData *logData = [[NSFileManager defaultManager] contentsAtPath:[logFileInfo filePath]];
        if ([logData length] > 0) {
            NSString *result = [[NSString alloc] initWithBytes:[logData bytes]
                                                        length:[logData length]
                                                      encoding: NSUTF8StringEncoding];
            
            [description appendString:result];
        }
    }
    
    if ([description length] > maxSize) {
        description = (NSMutableString *)[description substringWithRange:NSMakeRange([description length]-maxSize-1, maxSize)];
    }
    
    return description;
}


#pragma mark - BITCrashManagerDelegate

- (NSString *)applicationLogForCrashManager:(BITCrashManager *)crashManager {
    NSString *description = [self getLogFilesContentWithMaxSize:5000]; // 5000 bytes should be enough!
    if ([description length] == 0) {
        return nil;
    } else {
        return description;
    }
}

@end
