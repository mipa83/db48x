#ifndef OBJECT_H
#define OBJECT_H
// ****************************************************************************
//  object.h                                                      DB48X project
// ****************************************************************************
//
//   File Description:
//
//     The basic RPL object
//
//     An RPL object is a bag of bytes densely encoded using LEB128
//
//     It is important that the base object be empty, sizeof(object) == 1
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
//
//  RPL objects are encoded using sequence of LEB128 values
//  An LEB128 value is a variable-length encoding with 7 bits per byte,
//  the last byte having its high bit clear. This, values 0-127 are coded
//  as 0-127, values up to 16384 are coded on two bytes, and so on.
//
//  The reason for this encoding is that the DM42 is very memory-starved
//  (~70K available to DMCP programs), so chances of a size exceeding 2 bytes
//  are exceedingly rare. We can also use the lowest opcodes for the most
//  frequently used features, ensuring that 128 of them can be encoded on one
//  byte only. Similarly, all constants less than 128 can be encoded in two
//  bytes only (one for the opcode, one for the value), and all constants less
//  than 16384 are encoded on three bytes.
//
//  The opcode is an index in an object-handler table, so they act either as
//  commands or as types


#include "types.h"
#include "leb128.h"

struct runtime;

struct object
// ----------------------------------------------------------------------------
//  The basic RPL object
// ----------------------------------------------------------------------------
{
    enum id
    // ------------------------------------------------------------------------
    //  Object ID
    // ------------------------------------------------------------------------
    {
#define ID(i)   ID_##i,
#include <id.h>
        NUM_IDS
    };

    object(id i)
    // ------------------------------------------------------------------------
    //  Write the id of the object
    // ------------------------------------------------------------------------
    {
        byte *ptr = (byte *) this;
        leb128(ptr, i);
    }
    ~object() {}


    // ========================================================================
    //
    //   Object command protocol
    //
    // ========================================================================

    enum command
    // ------------------------------------------------------------------------
    //  The commands that all handlers must deal with
    // ------------------------------------------------------------------------
    {
        EVAL,                   // Evaluate the object (e.g. push on stack)
        SIZE,                   // Compute the size of the object
        PARSE,                  // Parse the object
        RENDER,                 // Render the object
    };

    enum result
    // ------------------------------------------------------------------------
    //   Common return values for handlers
    // ------------------------------------------------------------------------
    {
        OK    = 0,              // Command ran successfully
        SKIP  = -1,             // Command not for this handler, try next
        ERROR = -2,             // Error processing the command
    };



    // ========================================================================
    //
    //   Memory management
    //
    // ========================================================================

    static size_t required_memory(id i)
    // ------------------------------------------------------------------------
    //  Compute the amount of memory required for an object
    // ------------------------------------------------------------------------
    {
        return leb128size(i);
    }


    id type()
    // ------------------------------------------------------------------------
    //   Return the type of the object
    // ------------------------------------------------------------------------
    {
        byte *ptr = (byte *) this;
        return (id) leb128(ptr);
    }


    size_t size(runtime &rt = RT)
    // ------------------------------------------------------------------------
    //  Compute the size of the object by calling the handler with SIZE
    // ------------------------------------------------------------------------
    {
        return (size_t) run(rt, SIZE);
    }

    object *skip(runtime &rt = RT)
    // ------------------------------------------------------------------------
    //  Return the pointer to the next object in memory by skipping its size
    // ------------------------------------------------------------------------
    {
        return this + size(rt);
    }

    byte * payload()
    // ------------------------------------------------------------------------
    //  Return the object's payload, i.e. first byte after ID
    // ------------------------------------------------------------------------
    {
        byte *ptr = (byte *) this;
        leb128(ptr);            // Skip ID
        return ptr;
    }


    void evaluate(runtime &rt = RT)
    // ------------------------------------------------------------------------
    //  Evaluate an object by calling the handler
    // ------------------------------------------------------------------------
    {
        run(rt, EVAL);
    }

    size_t render(char *output, cstring end, runtime &rt = RT)
    // ------------------------------------------------------------------------
    //    Render the object according to its type
    // ------------------------------------------------------------------------
    {
        renderer r = { .begin = output, .end = end };
        return run(rt, RENDER, &r);
    }

    static object *parse(cstring beg, cstring *end = nullptr, runtime &rt = RT)
    // ------------------------------------------------------------------------
    //  Try parsing the object as a top-level temporary
    // ------------------------------------------------------------------------
    {
        parser p = { .begin = beg, .end = nullptr, .output = nullptr };
        result r = SKIP;

        // Try parsing with the various handlers
        for (uint i = 0; r == SKIP && i < NUM_IDS; i++)
        {
            p.candidate = id(i);
            r = (result) handler[i](rt, PARSE, &p, nullptr, nullptr);
        }

        if (end)
            *end = p.end;

        return r == OK ? p.output : nullptr;
    }


    static intptr_t run(runtime &rt, id type, command cmd, void *arg = nullptr)
    // ------------------------------------------------------------------------
    //  Run a command without an object
    // ------------------------------------------------------------------------
    {
        if (type >= NUM_IDS)
            return -1;
        return handler[type](rt, cmd, arg, nullptr, nullptr);
    }

    intptr_t run(runtime &rt, command cmd, void *arg = nullptr)
    // ------------------------------------------------------------------------
    //  Run an arbitrary command on the object
    // ------------------------------------------------------------------------
    {
        byte *ptr = (byte *) this;
        id type = (id) leb128(ptr); // Don't use type() to update payload
        if (type >= NUM_IDS)
            return -1;
        return handler[type](rt, cmd, arg, this, (object *) ptr);
    }

    static cstring name(id i)
    // ------------------------------------------------------------------------
    //   Return the name for a given ID
    // ------------------------------------------------------------------------
    {
        return id_name[i];
    }



protected:
    struct parser
    // ------------------------------------------------------------------------
    //  Arguments to the PARSE command
    // ------------------------------------------------------------------------
    {
        id      candidate; // Candidate ID for lookup
        cstring begin;
        cstring end;
        object *output;
    };

    struct renderer
    // ------------------------------------------------------------------------
    //  Arguments to the RENDER command
    // ------------------------------------------------------------------------
    {
        char   *begin;          // Buffer where we can write
        cstring end;
    };



#define OBJECT_PARSER(type)                                             \
    static result object_parser(cstring begin, cstring *end,            \
                                object **out,                           \
                                runtime & UNUSED rt = RT)

#define OBJECT_PARSER_BODY(type)                            \
  object::result type::object_parser(cstring         begin, \
                                     cstring        *end,   \
                                     object        **out,   \
                                     runtime &UNUSED rt)

#define OBJECT_RENDERER(type)                           \
    intptr_t object_renderer(char *begin, cstring end,  \
                             runtime &UNUSED rt = RT)

#define OBJECT_RENDERER_BODY(type)                              \
    intptr_t type::object_renderer(char *begin, cstring end,    \
                                   runtime &UNUSED rt)


    // The actual work is done here
#define OBJECT_HANDLER_NO_ID(type)                              \
    static intptr_t object_handler(runtime & UNUSED rt,         \
                                   command   UNUSED cmd,        \
                                   void    * UNUSED arg,        \
                                   type    * UNUSED obj,        \
                                   object  * UNUSED payload)

#define OBJECT_HANDLER(type)                            \
    static id static_type() { return ID_##type; }       \
    OBJECT_HANDLER_NO_ID(type)

#define OBJECT_HANDLER_BODY(type)                               \
    intptr_t type::object_handler(runtime & UNUSED rt,          \
                                  command   UNUSED cmd,         \
                                  void    * UNUSED arg,         \
                                  type  *   UNUSED obj,         \
                                  object  * UNUSED payload)

    // The default object handlers
    OBJECT_PARSER(object);
    OBJECT_RENDERER(object);
    OBJECT_HANDLER_NO_ID(object);


#define DELEGATE(base)                                  \
    base::object_handler(rt, cmd, arg, obj, payload)

    template <typename T, typename U>
    static intptr_t ptrdiff(T *t, U *u)
    {
        return (byte *) t - (byte *) u;
    }


  protected:
    typedef intptr_t (*handler_fn)(runtime &rt,
                                   command cmd, void *arg,
                                   object *obj, object *payload);
    static const handler_fn handler[NUM_IDS];
    static const cstring    id_name[NUM_IDS];
    static runtime         &RT;
};


#endif // OBJECT_H
