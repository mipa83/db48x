// ****************************************************************************
//  AppDelegate.mm                                               DB48X project
// ****************************************************************************
//
//   File Description:
//
//     Basic iOS application infrastructure
//
//
//
//
//
//
//
//
// ****************************************************************************
//   (C) 2024 Christophe de Dinechin <christophe@dinechin.org>
//   This software is licensed under the terms outlined in LICENSE.txt
// ****************************************************************************
//   This file is part of DB48X.
//
//   DB48X is free software: you can redistribute it and/or modify
//   it under the terms outlined in the LICENSE.txt file
//
//   DB48X is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// ****************************************************************************

#import "AppDelegate.h"
#import "AppSettings.h"

#include "dmcp.h"
#include "tests.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
// ----------------------------------------------------------------------------
//   Application launch
// ----------------------------------------------------------------------------
{
    // Load user settings
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    theAppSettings.saveState = ![settings boolForKey:@"DisableSaveState"];
    theAppSettings.hapticFeedback = ![settings boolForKey:@"DisableHapticFeedback"];

    // Change directory to the app bundle
    NSString *folder = [[NSBundle mainBundle] resourcePath];
    chdir([folder cStringUsingEncoding:[NSString defaultCStringEncoding]]);

    // Dispatch the RPL thread
    dispatch_queue_t queue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
            program_main();
        });

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
// ----------------------------------------------------------------------------
//   Moving from active to inactive state
// ----------------------------------------------------------------------------
// Sent when the application is about to move from active to inactive  state.
// This can occur for certain types of temporary interruptions (such as
// an incoming phone call or SMS message) or when the user quits the application
// and it begins the transition to the background state.
//
// Use this method to pause ongoing tasks, disable timers, and throttle down
// OpenGL ES frame rates. Games should use this method to pause the game.
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:!theAppSettings.saveState
               forKey:@"DisableSaveState"];
    [settings setBool:!theAppSettings.hapticFeedback
               forKey:@"DisableHapticFeedback"];
    if (theAppSettings.saveState)
        key_push(tests::EXIT_PGM);
}


- (void)applicationDidEnterBackground:(UIApplication *)application
// ----------------------------------------------------------------------------
//   Entering background
// ----------------------------------------------------------------------------
// Use this method to release shared resources, save user data,
// invalidate timers, and store enough application state information to
// restore your application to its current state in case it is terminated later.
// If your application supports background execution, this method is called
// instead of applicationWillTerminate: when the user quits.
{
}


- (void)applicationWillEnterForeground:(UIApplication *)application
// ----------------------------------------------------------------------------
//   Transition from background to inactive state
// ----------------------------------------------------------------------------
// Here you can undo many of the changes made on entering the background.
{
}


- (void)applicationDidBecomeActive:(UIApplication *)application
// ----------------------------------------------------------------------------
//    Application becomes active
// ----------------------------------------------------------------------------
// Restart any tasks that were paused (or not yet started) while the
// application was inactive. If the application was previously in the
// background, optionally refresh the user interface.
{
}


- (void)applicationWillTerminate:(UIApplication *)application
// ----------------------------------------------------------------------------
//    Application is about to terminate
// ----------------------------------------------------------------------------
//   Save data if appropriate. See also applicationDidEnterBackground:.
{
    [self applicationWillResignActive:application];
}

@end
