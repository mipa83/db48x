// ****************************************************************************
//  ViewController.mm                                             DB48X project
// ****************************************************************************
//
//   File Description:
//
//     View controller for the DB48X application
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

#import "ViewController.h"
#import "Screen.hpp"
#import "Keyboard.hpp"

@interface ViewController ()
// ----------------------------------------------------------------------------
//    The view controller sets up the various elements
// ----------------------------------------------------------------------------
{
    Screen             screen;
    Keyboard           keyboard;
    IBOutlet UIButton *helloButton;
}
@end

@implementation ViewController

- (void)viewDidLoad
// ----------------------------------------------------------------------------
//   Setup after loading the view
// ----------------------------------------------------------------------------
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
// ----------------------------------------------------------------------------
//   Low memory: Dispose of resources that can be recreated
// ----------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
