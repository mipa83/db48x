#ifndef MAIN_H
#define MAIN_H
// ****************************************************************************
//  main.h                                                        DB48X project
// ****************************************************************************
//
//   File Description:
//
//     Defines for the main entry point
//
//
//
//
//
//
//
//
// ****************************************************************************
//   (C) 2022 Christophe de Dinechin <christophe@dinechin.org>
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

#include "version.h"

#if NOSAVE
#define PROGRAM_NAME    "DB40X"
#elif !DM32
#define PROGRAM_NAME    "DB48X"
#else
#define PROGRAM_NAME    "DB50X"
#endif
#define PROGRAM_VERSION DB48X_VERSION

#define PROGRAM_KEYMAP_ID 0x38344244

#endif // MAIN_H
