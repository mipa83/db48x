// ****************************************************************************
//  SettingsViewController.m                                      DB48X project
// ****************************************************************************
//
//   File Description:
//
//
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

#import "SettingsViewController.h"
#import "HelpViewController.h"
#import "AppSettings.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *saveStateOnExitSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saveStateWhenMovingToBackgroundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *hapticFeedbackSwitch;

@end


AppSettings theAppSettings =
// ----------------------------------------------------------------------------
//  Global application settings
// ----------------------------------------------------------------------------
{
    .saveStateOnExit                 = true,
    .saveStateWhenMovingToBackground = false,
    .hapticFeedback                  = true
};


@implementation SettingsViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
// ----------------------------------------------------------------------------
//   Select the target URL based on where we come from
// ----------------------------------------------------------------------------
{
    NSString *url = nil;

    HelpViewController *help = (HelpViewController *) segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"help"])
    {
        url = @"https://github.com/c3d/DB48X-on-DM42/blob/stable/help/db50x.md";
    }
    else if ([segue.identifier isEqualToString:@"issues"])
    {
        url = @"https://github.com/c3d/DB48X-on-DM42/issues";
    }
    if (url)
        [help setURL:url];
}


- (void)viewDidLoad
// ----------------------------------------------------------------------------
//   Adjust the settings widgets to match the settings values
// ----------------------------------------------------------------------------
{
    [super viewDidLoad];

    // Load preferences into the switches
    self.saveStateOnExitSwitch.on = theAppSettings.saveStateOnExit;
    self.saveStateWhenMovingToBackgroundSwitch.on = theAppSettings.saveStateWhenMovingToBackground;
    self.hapticFeedbackSwitch.on = theAppSettings.hapticFeedback;
}


- (IBAction)saveSettingsOnExitSwitched:(UISwitch *)sender
// ----------------------------------------------------------------------------
//   Adjust the setting to match widget
// ----------------------------------------------------------------------------
{
    theAppSettings.saveStateOnExit = sender.on;
}

- (IBAction)saveSettingWhenMovingToBackground:(UISwitch *)sender
// ----------------------------------------------------------------------------
//   Adjust the setting to match widget
// ----------------------------------------------------------------------------
{
    theAppSettings.saveStateWhenMovingToBackground = sender.on;
}

- (IBAction)hapticFeedbackChanged:(UISwitch *)sender
// ----------------------------------------------------------------------------
//   Adjust the setting to match widget
// ----------------------------------------------------------------------------
{
    theAppSettings.hapticFeedback = sender.on;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
