//
//  HockeyAppPlugin.m
//

#import <HockeySDK/HockeySDK.h>

#import "HockeyAppPlugin.h"
#import "DDFileLogger.h"

extern int ddLogLevel;

@interface HockeyAppPlugin ()

@property (nonatomic) DDFileLogger *fileLogger;

@end

@implementation HockeyAppPlugin

#pragma mark Initialization

- (void)pluginInitialize {
    NSString * hockeyAppKey = @"__HOCKEY_APP_KEY__";
    if( hockeyAppKey!=nil && [hockeyAppKey isEqualToString:@""]==NO && [hockeyAppKey rangeOfString:@"HOCKEY_APP_KEY"].location == NSNotFound ){

        // initialize before HockeySDK, so the delegate can access the file logger
        self.fileLogger = [[DDFileLogger alloc] init];
        self.fileLogger.maximumFileSize = (1024 * 64); // 64 KByte
        self.fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
        [self.fileLogger rollLogFileWithCompletionBlock:nil];
        [DDLog addLogger:self.fileLogger];
        
        [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:hockeyAppKey
                                                             liveIdentifier:hockeyAppKey
                                                                   delegate:self];
        
        [[BITHockeyManager sharedHockeyManager] startManager];
        [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    }
    
    DDLogInfo(@"HockeyApp Plugin initialized");
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
