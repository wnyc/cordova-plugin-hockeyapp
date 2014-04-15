//
//  HockeyAppPlugin.m
//  NYPRNative
//
//  Created by Bradford Kammin on 4/1/14.
//
//

#import <HockeySDK/HockeySDK.h>

#import "HockeyAppPlugin.h"

@implementation HockeyAppPlugin

#pragma mark Initialization

- (void)pluginInitialize
{
    NSString * hockeyAppKey = @"__HOCKEY_APP_KEY__";
    if( hockeyAppKey!=nil && [hockeyAppKey isEqualToString:@""]==NO && [hockeyAppKey rangeOfString:@"HOCKEY_APP_KEY"].location == NSNotFound ){
        
        [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:hockeyAppKey
                                                             liveIdentifier:hockeyAppKey
                                                                   delegate:self];
        
        [[BITHockeyManager sharedHockeyManager] startManager];
        [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    }
    
    NSLog(@"HockeyApp Plugin initialized");
}

@end
