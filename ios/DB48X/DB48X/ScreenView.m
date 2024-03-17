// ****************************************************************************
//  ScreenView.m                                                  DB48X project
// ****************************************************************************
//
//   File Description:
//
//     Draw the DMCP screen
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

#import "ScreenView.h"
#include "recorder.h"

#include "sim-dmcp.h"
#include <stdint.h>


// Copy of the pixel data
byte pixelData[SIM_LCD_W * SIM_LCD_H * 4];
byte lcd_copy[SIM_LCD_SCANLINE * SIM_LCD_H / 8];

RECORDER(screenview, 256, "Screen view image generation");


@implementation ScreenView
// ----------------------------------------------------------------------------
//   Data associated with a screen view
// ----------------------------------------------------------------------------
{
    uint refreshed;             // Number of times we rebuilt the image
}


- (id) init
// ----------------------------------------------------------------------------
//   Initialization
// ----------------------------------------------------------------------------
{
    self = [super init];
    if (self)
        refreshed = 0;
    return self;
}


- (unsigned) refreshCount
// ----------------------------------------------------------------------------
//   Return the number of refresh
// ----------------------------------------------------------------------------
{
    return refreshed;
}


-(UIImage *)imageFromLCD
// ----------------------------------------------------------------------------
//   Build an image from the DMCP LCD representation
// ----------------------------------------------------------------------------
//   This can (and should) run on the RPL thread
{
    record(screenview, "%u: imageFromLCD", refreshed);

    size_t bytesPerRow = SIM_LCD_W * 4;

    for (int y = 0; y < SIM_LCD_H; y++)
    {
        for (int xb = 0; xb < SIM_LCD_W/8; xb++)
        {
            unsigned byteoffs = y * (SIM_LCD_SCANLINE/8) + xb;
            byte diffs = lcd_copy[byteoffs] ^ lcd_buffer[byteoffs];
            if (diffs)
            {
                for (int bit = 0; bit < 8; bit++)
                {
                    if ((diffs >> bit) & 1)
                    {
                        int x = 8*xb + bit;
                        int on = (lcd_buffer[byteoffs] >> bit) & 1;
                        uint pixoffs = y * SIM_LCD_W + (SIM_LCD_W - 1 - x);
                        byte *pixel = &pixelData[pixoffs * 4];
                        byte pixval = on ? 220 : 0;
                        pixel[0] = pixel[1] = pixel[2] = pixel[3] = pixval;
                    }
                }
                lcd_copy[byteoffs] = lcd_buffer[byteoffs];
            }
        }
    }


    void *baseAddress = &pixelData;
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    CGContextRef    context     = CGBitmapContextCreate(
        baseAddress,
        SIM_LCD_W,
        SIM_LCD_H,
        8,
        bytesPerRow,
        colorSpace,
        kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);

    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    record(screenview, "%u: imageFromLCD returns %p [%llu]",
           refreshed, (__bridge void *) image);

    refreshed++;

    return image;
}

@end
