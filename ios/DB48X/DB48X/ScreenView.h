// ****************************************************************************
//  ScreenView.h                                                  DB48X project
// ****************************************************************************
//
//   File Description:
//
//     The view where we render the DMCP screen
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

NS_ASSUME_NONNULL_BEGIN

@interface ScreenView : UIImageView

- (UIImage *) imageFromLCD;

@end

NS_ASSUME_NONNULL_END
