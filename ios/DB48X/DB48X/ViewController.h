// ****************************************************************************
//  ViewController.h                                              DB48X project
// ****************************************************************************
//
//   File Description:
//
//     View controller deals with keyboard
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

#import <UIKit/UIKit.h>
#import <MetalKit/MTKView.h>
#import <UIKit/UIImageView.h>

@interface ViewController : UIViewController<UIGestureRecognizerDelegate>
// ----------------------------------------------------------------------------
//   View controller interface
// ----------------------------------------------------------------------------
{
    __weak IBOutlet MTKView *screenView;
    __weak IBOutlet UIImageView *keyboardView;
}
@end
