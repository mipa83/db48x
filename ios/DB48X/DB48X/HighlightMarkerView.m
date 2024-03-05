// ****************************************************************************
//  HighlightMarkerView.m                                         DB48X project
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

#import "HighlightMarkerView.h"

@implementation HighlightMarkerView

- (void)drawRect:(CGRect)rect
// ----------------------------------------------------------------------------
//    Draw in the given rectangle
// ----------------------------------------------------------------------------
{
    CGRect bounds = CGRectInset([self bounds], 2, 2);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect: bounds cornerRadius: 4];
    [[UIColor systemYellowColor] setFill];
    [roundedRect fillWithBlendMode: kCGBlendModeNormal alpha:0.3];
    [[UIColor systemYellowColor] setStroke];
    [roundedRect setLineWidth:4.0];
    [roundedRect strokeWithBlendMode:kCGBlendModeNormal alpha:0.9];
}

@end
