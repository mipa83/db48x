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
@property (weak, nonatomic) IBOutlet UISwitch *hapticFeedbackSwitch;

@end

AppSettings theAppSettings =
{
saveState: true,
hapticFeedback: true
};


@implementation SettingsViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HelpViewController *help = (HelpViewController *) segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"help"])
    {
        [help setURL:@"https://github.com/c3d/DB48X-on-DM42/blob/stable/help/db50x.md"];
    }
    else if ([segue.identifier isEqualToString:@"issues"])
    {
        [help setURL:@"https://github.com/c3d/DB48X-on-DM42/issues"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.saveStateOnExitSwitch.on = theAppSettings.saveState;
    self.hapticFeedbackSwitch.on = theAppSettings.hapticFeedback;
}

- (IBAction)saveSettingsSwitched:(UISwitch *)sender {
    theAppSettings.saveState = sender.on;
}

- (IBAction)hapticFeedbackChanged:(UISwitch *)sender {
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
