// ****************************************************************************
//  main.mm                                                       DB48X project
// ****************************************************************************
//
//   File Description:
//
//     Main iOS entry point for DB48X
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

#include "object.h"
#include "recorder.h"
#include "version.h"


#import <UIKit/UIKit.h>
#import "AppDelegate.h"


RECORDER(options, 32, "Information about command line options");

bool run_tests = false;
bool db48x_keyboard = true;
uint memory_size = 70;           // Memory size in kilobytes
extern uint wait_time;
extern uint delay_time;



size_t recorder_render_object(intptr_t tracing,
                              const char *UNUSED format,
                              char *buffer, size_t size,
                              uintptr_t arg)
// ----------------------------------------------------------------------------
//   Render a value during a recorder dump (%t format)
// ----------------------------------------------------------------------------
{
    object_p value = object_p(arg);
    size_t result = 0;
    if (tracing)
    {
        if (value)
        {
            char tmp[80];
            size_t sz =  value->render(tmp, sizeof(tmp)-1);
            tmp[sz] = 0;
            result = snprintf(buffer, size, "%p[%lu] %s[%s]",
                              (void *) value,
                              value->size(),
                              value->fancy(),
                              tmp);
        }
        else
        {
            result = snprintf(buffer, size, "0x0 <NULL>");
        }
    }
    else
    {
        result = snprintf(buffer, size, "%p", (void *) value);
    }
    return result;
}


// Ensure linker keeps debug code
extern cstring debug();


int main(int argc, char * argv[])
// ----------------------------------------------------------------------------
//   Boilerplate application code
// ----------------------------------------------------------------------------
{
    const char *traces = getenv("DB48X_TRACES");
    recorder_trace_set(".*(error|warning)s?");
    if (traces)
        recorder_trace_set(traces);
    recorder_dump_on_common_signals(0, 0);
    recorder_configure_type('t', recorder_render_object);

    // This is just to link otherwise unused code intended for use in debugger
    if (traces && traces[0] == char(0xFF))
        if (cstring result = debug())
            record(options, "Strange input %s", result);

    // Indicate the first two-byte opcode
    fprintf(stderr,
            "DB48X version %s\n"
            "Last single-byte opcode is %s\n"
            "First two byte opcode is %s\n",
            DB48X_VERSION,
            object::name(object::id(127)),
            object::name(object::id(128)));

    record(options,
           "Simulator invoked as %+s with %d arguments", argv[0], argc-1);
    for (int a = 1; a < argc; a++)
    {
        record(options, "  %u: %+s", a, argv[a]);
        if (argv[a][0] == '-')
        {
            switch(argv[a][1])
            {
            case 't':
                recorder_trace_set(argv[a]+2);
                break;
            case 'T':
                run_tests = true;
            case 'O':
                if (argv[a][2])
                {
                    static bool first = true;
                    if (first)
                    {
                        recorder_trace_set("est_.*=0");
                        first = false;
                    }
                    char tname[256];
                    if (strcmp(argv[a]+2, "all") == 0)
                        strcpy(tname, "est_.*");
                    else
                        snprintf(tname, sizeof(tname)-1, "est_%s", argv[a]+2);
                    recorder_trace_set(tname);
                }
                break;
            case 'k':
                db48x_keyboard = true;
                break;
            case 'w':
                if (argv[a][2])
                    wait_time = atoi(argv[a]+2);
                else if (a < argc)
                    wait_time = atoi(argv[++a]);
                break;
            case 'd':
                if (argv[a][2])
                    delay_time = atoi(argv[a]+2);
                else if (a < argc)
                    delay_time = atoi(argv[++a]);
                break;
            case 'm':
                if (argv[a][2])
                    memory_size = atoi(argv[a]+2);
                else if (a < argc)
                    memory_size = atoi(argv[++a]);
                break;
            }
        }
    }

    @autoreleasepool
    {
        return UIApplicationMain(argc, argv, nil,
                                 NSStringFromClass([AppDelegate class]));
    }
}
