// ****************************************************************************
//  HelpViewController.m                                          DB48X project
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

#import "HelpViewController.h"
#import <WebKit/WKWebViewConfiguration.h>
#import <WebKit/WKWebView.h>

@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *helpView;
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *helpURL = [NSURL URLWithString:@"https://github.com/c3d/DB48X-on-DM42/blob/stable/help/db50x.md"];
    NSURLRequest *helpReq = [NSURLRequest requestWithURL:helpURL];
    [self.helpView loadRequest:helpReq];
}

@end
