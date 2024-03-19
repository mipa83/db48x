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

#import "HighlightMarkerView.h"
#import "KeyboardView.h"
#import "ScreenView.h"

#import <UIKit/UIImageView.h>
#import <UIKit/UIKit.h>

@interface ViewController
    : UIViewController <UIGestureRecognizerDelegate,
                        UIDocumentPickerDelegate,
                        UIDocumentBrowserViewControllerDelegate>
// ----------------------------------------------------------------------------
//   View controller interface
// ----------------------------------------------------------------------------
{
    __weak IBOutlet ScreenView *screenView;
    __weak IBOutlet KeyboardView *keyboardView;
    __weak IBOutlet HighlightMarkerView *highlightView;
}
@end

struct tapmap
// ----------------------------------------------------------------------------
//   Conversion between in-image coordinates and keys
// ----------------------------------------------------------------------------
{
    int key, keynum;
    float left, right, top, bot;
};

extern struct tapmap tapMap[];
