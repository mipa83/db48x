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

#include <stdint.h>

#define LCD_W           400
#define LCD_H           240
#define LCD_SCANLINE    416


typedef uint8_t byte;

extern uint8_t  lcd_buffer[LCD_SCANLINE * LCD_H / 8];


@implementation ScreenView

-(UIImage *)imageFromLCD
{
    byte pixelData[LCD_W * LCD_H * 4];
    size_t bytesPerRow = LCD_W * 4;

    for (int y = 0; y < LCD_H; y++)
    {
        for (int x = 0; x < LCD_W; x++)
        {
            unsigned bo = y * LCD_SCANLINE + x;
            int on = (lcd_buffer[bo/8] >> (bo % 8)) & 1;
            byte *pixel = &pixelData[(y * LCD_W + (LCD_W - 1 - x)) * 4];
            pixel[0] = pixel[1] = pixel[2] = pixel[3] = on ? 255 : 0;
        }
    }
    void *baseAddress = &pixelData;


    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef    context     = CGBitmapContextCreate(
        baseAddress,
        LCD_W, LCD_H,
        8,
        bytesPerRow,
        colorSpace,
        kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);

    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);

    return image;
}

@end
