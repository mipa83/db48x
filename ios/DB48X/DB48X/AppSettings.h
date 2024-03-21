#ifndef APP_SETTINGS_H
#define APP_SETTINGS_H
// ****************************************************************************
//  AppSettings.h                                                 DB48X project
// ****************************************************************************
//
//   File Description:
//
//     Store the settings for the application
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

typedef struct AppSettings
// ----------------------------------------------------------------------------
//   Settings for the application
// ----------------------------------------------------------------------------
{
    bool        saveStateOnExit;
    bool        saveStateWhenMovingToBackground;
    bool        hapticFeedback;
} AppSettings;

extern AppSettings theAppSettings;

#endif // APP_SETTINGS_H
