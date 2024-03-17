// ****************************************************************************
//  ViewController.mm                                             DB48X project
// ****************************************************************************
//
//   File Description:
//
//     View controller for the DB48X application
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

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#include "sim-dmcp.h"
#include "dmcp.h"

#ifdef DEBUG
#include "tests.h"
#endif

#include <time.h>


RECORDER(ui_images, 32, "Transfers of UIImage");


@interface ViewController ()
// ----------------------------------------------------------------------------
//    The view controller sets up the various elements
// ----------------------------------------------------------------------------
@end


struct tapmap tapMap[] =
// ----------------------------------------------------------------------------
//   Identify the position of the keys on virtual keyboard
// ----------------------------------------------------------------------------
{

    { 1,        38, 0.03, 0.15, 0.03, 0.10 },
    { 2,        39, 0.20, 0.32, 0.03, 0.10 },
    { 3,        40, 0.345, 0.47, 0.03, 0.10 },
    { 4,        41, 0.52, 0.63, 0.03, 0.10 },
    { 5,        42, 0.68, 0.80, 0.03, 0.10 },
    { 6,        43, 0.83, 0.95, 0.03, 0.10 },

    { 'a',       1, 0.03, 0.15, 0.15, 0.22 },
    { 'b',       2, 0.20, 0.32, 0.15, 0.22 },
    { 'c',       3, 0.345, 0.47, 0.15, 0.22 },
    { 'd',       4, 0.52, 0.63, 0.15, 0.22 },
    { 'e',       5, 0.68, 0.80, 0.15, 0.22 },
    { 'f',       6, 0.83, 0.95, 0.15, 0.22 },

    { 'g',       7, 0.03, 0.15, 0.275, 0.345 },
    { 'h',       8, 0.20, 0.32, 0.275, 0.345 },
    { 'i',       9, 0.345, 0.47, 0.275, 0.345 },
    { 'j',      10, 0.52, 0.63, 0.275, 0.345 },
    { 'k',      11, 0.68, 0.80, 0.275, 0.345 },
    { 'l',      12, 0.83, 0.95, 0.275, 0.345 },

    { '\n',     13, 0.03, 0.32, 0.40, 0.47 },
    { 'm',      14, 0.345, 0.47, 0.40, 0.47 },
    { 'n',      15, 0.51, 0.64, 0.40, 0.47 },
    { 'o',      16, 0.68, 0.80, 0.40, 0.47 },
    { 8,        17, 0.83, 0.95, 0.40, 0.47 },

    { 10,       18, 0.03, 0.15, 0.52, 0.59 },
    { '7',      19, 0.23, 0.36, 0.52, 0.59 },
    { '8',      20, 0.42, 0.56, 0.52, 0.59 },
    { '9',      21, 0.62, 0.75, 0.52, 0.59 },
    { '/',      22, 0.81, 0.95, 0.52, 0.59 },

    { 11,       23, 0.03, 0.15, 0.645, 0.715 },
    { '4',      24, 0.23, 0.36, 0.645, 0.715 },
    { '5',      25, 0.42, 0.56, 0.645, 0.715 },
    { '6',      26, 0.62, 0.75, 0.645, 0.715 },
    { '*',      27, 0.81, 0.95, 0.645, 0.715 },

    { '^',      28, 0.028, 0.145, 0.77, 0.84 },
    { '1',      29, 0.23, 0.36, 0.77, 0.84 },
    { '2',      30, 0.42, 0.56, 0.77, 0.84 },
    { '3',      31, 0.62, 0.75, 0.77, 0.84 },
    { '-',      32, 0.81, 0.95, 0.77, 0.84 },

    { '\e',     33, 0.03, 0.15, 0.89, 0.97 },
    { '0',      34, 0.23, 0.36, 0.89, 0.97 },
    { '.',      35, 0.42, 0.55, 0.89, 0.97 },
    { '?',      36, 0.62, 0.74, 0.89, 0.97 },
    { '+',      37, 0.81, 0.95, 0.89, 0.97 },

    { 0,  0,      0.0,      0.0,      0.0,      0.0}
};

extern "C" void program_main();

ViewController *theViewController = nullptr;


@implementation ViewController
// ----------------------------------------------------------------------------
//   Implementation of the main view controller for DB48X
// ----------------------------------------------------------------------------
{
    AVAudioEngine *audio;
    float phase;
    uint requests;
    uint redraws;
};


- (void)viewDidLoad
// ----------------------------------------------------------------------------
//   Setup after loading the view
// ----------------------------------------------------------------------------
{
    [super viewDidLoad];

    theViewController = self;
    requests = 0;
    redraws = 0;

#if 0
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:&error];
    NSLog(@"Directory content %@", directoryContents);
    for (NSString *file in directoryContents)
        NSLog(@"file %@", file);
#endif
}


-(void) refreshScreenWithImage:(UIImage *)image
// ----------------------------------------------------------------------------
//  Refresh the screen
// ----------------------------------------------------------------------------
{
    record(ui_images, "%u/%u: Setting UI Image from %p to %p",
           requests, redraws, screenView.image, image);
    screenView.image = image;
    redraws++;
}


-(void) refresh
// ----------------------------------------------------------------------------
//   Mark the screen as needing a refresh
// ----------------------------------------------------------------------------
{
    record(ui_images, "%u/%u: Refresh request", requests, redraws);
    if (redraws == requests)
    {
        @autoreleasepool
        {
            UIImage *image = [screenView imageFromLCD];
            if (image)
            {
                requests++;
                record(ui_images,
                       "%u/%u: Dispatch request for image %p",
                       requests, redraws, image);
                dispatch_async(dispatch_get_main_queue(), ^{
                        record(ui_images,
                               "%u/%u: Dispatched request for %p",
                               self->requests, self->redraws, image);
                        [self refreshScreenWithImage:image];
                    });
            }
            else
            {
                recorder_dump();
            }
        }
    }
}


-(unsigned) refreshCount
// ----------------------------------------------------------------------------
//   Return the refresh count for the view
// ----------------------------------------------------------------------------
{
    return [screenView refreshCount];
}


- (void) pushKeyHighlight:(int) key
// ----------------------------------------------------------------------------
//   Highlight the rectangle
// ----------------------------------------------------------------------------
{
    CGRect rect = CGRect();
    CGFloat width = keyboardView.frame.size.width;
    CGFloat height = keyboardView.frame.size.height;
    CGFloat x0 = keyboardView.frame.origin.x;
    CGFloat y0 = keyboardView.frame.origin.y;
    bool hidden = true;
    for (tapmap *ptr = tapMap; ptr->key; ptr++)
    {
        if (ptr->keynum == key)
        {
            CGFloat x = ptr->left * width + x0;
            CGFloat y = ptr->top * height + y0;
            CGFloat w = (ptr->right - ptr->left) * width;
            CGFloat h = (ptr->bot - ptr->top) * height;
            rect = CGRectMake(x, y, w, h);
            hidden = false;
            break;
        }
    }

    [highlightView setFrame:rect];
    highlightView.hidden = hidden;
}


- (void) pressesBegan:(NSSet<UIPress *> *)presses
            withEvent:(UIPressesEvent *)event
// ----------------------------------------------------------------------------
//   Physical key being pressed
// ----------------------------------------------------------------------------
{
    for(UIPress* press in presses) {
        UIKey *key = press.key;
        if (!key)
            continue;
        int dkey = 0;
        switch (key.keyCode)
        {
        case UIKeyboardHIDUsageKeyboardA: dkey = KEY_SIGMA; break;
        case UIKeyboardHIDUsageKeyboardB: dkey = KEY_INV; break;
        case UIKeyboardHIDUsageKeyboardC: dkey = KEY_SQRT; break;
        case UIKeyboardHIDUsageKeyboardD: dkey = KEY_LOG; break;
        case UIKeyboardHIDUsageKeyboardE: dkey = KEY_LN; break;
        case UIKeyboardHIDUsageKeyboardF: dkey = KEY_XEQ; break;
        case UIKeyboardHIDUsageKeyboardG: dkey = KEY_STO; break;
        case UIKeyboardHIDUsageKeyboardH: dkey = KEY_RCL; break;
        case UIKeyboardHIDUsageKeyboardI: dkey = KEY_RDN; break;
        case UIKeyboardHIDUsageKeyboardJ: dkey = KEY_SIN; break;
        case UIKeyboardHIDUsageKeyboardK: dkey = KEY_COS; break;
        case UIKeyboardHIDUsageKeyboardL: dkey = KEY_TAN; break;
        case UIKeyboardHIDUsageKeypadEnter:
        case UIKeyboardHIDUsageKeyboardReturnOrEnter:
        case UIKeyboardHIDUsageKeyboardReturn: dkey = KEY_ENTER; break;
        case UIKeyboardHIDUsageKeyboardM: dkey = KEY_SWAP; break;
        case UIKeyboardHIDUsageKeyboardN: dkey = KEY_CHS; break;
        case UIKeyboardHIDUsageKeyboardO: dkey = KEY_E; break;
        case UIKeyboardHIDUsageKeyboardDeleteOrBackspace:
        case UIKeyboardHIDUsageKeyboardDeleteForward:    dkey = KEY_BSP; break;
        case UIKeyboardHIDUsageKeyboard7:
        case UIKeyboardHIDUsageKeypad7:
        case UIKeyboardHIDUsageKeyboardP: dkey = KEY_7; break;
        case UIKeyboardHIDUsageKeyboard8:
        case UIKeyboardHIDUsageKeypad8:
        case UIKeyboardHIDUsageKeyboardQ: dkey = KEY_8; break;
        case UIKeyboardHIDUsageKeyboard9:
        case UIKeyboardHIDUsageKeypad9:
        case UIKeyboardHIDUsageKeyboardR: dkey = KEY_9; break;
        case UIKeyboardHIDUsageKeypadSlash:
        case UIKeyboardHIDUsageKeyboardS: dkey = KEY_DIV; break;
        case UIKeyboardHIDUsageKeyboardLeftArrow:
        case UIKeyboardHIDUsageKeyboardUpArrow: dkey = KEY_UP; break;
        case UIKeyboardHIDUsageKeyboardRightArrow:
        case UIKeyboardHIDUsageKeyboardDownArrow: dkey = KEY_DOWN; break;
        case UIKeyboardHIDUsageKeypad4:
        case UIKeyboardHIDUsageKeyboard4:
        case UIKeyboardHIDUsageKeyboardT: dkey = KEY_4; break;
        case UIKeyboardHIDUsageKeyboard5:
        case UIKeyboardHIDUsageKeypad5:
        case UIKeyboardHIDUsageKeyboardU: dkey = KEY_5; break;
        case UIKeyboardHIDUsageKeyboard6:
        case UIKeyboardHIDUsageKeypad6:
        case UIKeyboardHIDUsageKeyboardV: dkey = KEY_6; break;
        case UIKeyboardHIDUsageKeypadAsterisk:
        case UIKeyboardHIDUsageKeyboardW: dkey = KEY_MUL; break;
        case UIKeyboardHIDUsageKeyboardCapsLock:
        case UIKeyboardHIDUsageKeyboardLockingCapsLock:
        case UIKeyboardHIDUsageKeyboardLeftShift:
        case UIKeyboardHIDUsageKeyboardRightShift:
        case UIKeyboardHIDUsageKeyboardLeftControl:
        case UIKeyboardHIDUsageKeyboardRightControl:
        case UIKeyboardHIDUsageKeyboardLeftAlt:
        case UIKeyboardHIDUsageKeyboardRightAlt:
        case UIKeyboardHIDUsageKeyboardTab: dkey = KEY_SHIFT; break;
        case UIKeyboardHIDUsageKeyboard1:
        case UIKeyboardHIDUsageKeypad1:
        case UIKeyboardHIDUsageKeyboardX: dkey = KEY_1; break;
        case UIKeyboardHIDUsageKeyboard2:
        case UIKeyboardHIDUsageKeypad2:
        case UIKeyboardHIDUsageKeyboardY: dkey = KEY_2; break;
        case UIKeyboardHIDUsageKeyboard3:
        case UIKeyboardHIDUsageKeypad3:
        case UIKeyboardHIDUsageKeyboardZ: dkey = KEY_3; break;
        case UIKeyboardHIDUsageKeypadHyphen:
        case UIKeyboardHIDUsageKeyboardHyphen: dkey = KEY_SUB; break;
        case UIKeyboardHIDUsageKeyboardEscape: dkey = KEY_EXIT; break;
        case UIKeyboardHIDUsageKeypad0:
        case UIKeyboardHIDUsageKeyboard0: dkey = KEY_0; break;
        case UIKeyboardHIDUsageKeyboardComma:
        case UIKeyboardHIDUsageKeypadComma:
        case UIKeyboardHIDUsageKeypadPeriod:
        case UIKeyboardHIDUsageKeyboardPeriod: dkey = KEY_DOT; break;
        case UIKeyboardHIDUsageKeypadEqualSign:
        case UIKeyboardHIDUsageKeypadEqualSignAS400:
        case UIKeyboardHIDUsageKeyboardEqualSign:
        case UIKeyboardHIDUsageKeyboardSpacebar: dkey = KEY_RUN; break;
        case UIKeyboardHIDUsageKeypadPlus: dkey = KEY_ADD; break;

        case UIKeyboardHIDUsageKeyboardF1: dkey = KEY_F1; break;
        case UIKeyboardHIDUsageKeyboardF2: dkey = KEY_F2; break;
        case UIKeyboardHIDUsageKeyboardF3: dkey = KEY_F3; break;
        case UIKeyboardHIDUsageKeyboardF4: dkey = KEY_F4; break;
        case UIKeyboardHIDUsageKeyboardF5: dkey = KEY_F5; break;
        case UIKeyboardHIDUsageKeyboardF6: dkey = KEY_F6; break;

#ifdef DEBUG
            // Running tests
        case UIKeyboardHIDUsageKeyboardF11:
            [self startTestWithSingle:true];
            break;
        case UIKeyboardHIDUsageKeyboardF12:
            [self startTestWithSingle:false];
            break;
#endif // Debug

        default: break;
        }

        if (dkey)
            key_push(dkey);
    }
}


#ifdef DEBUG
- (void) startTestWithSingle:(bool) single
// ----------------------------------------------------------------------------
//  Dispatch a test run
// ----------------------------------------------------------------------------
{
    dispatch_queue_t queue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
            tests suite;
            suite.run(single);
        });
}
#endif // DEBUG


- (void) pressesEnded:(NSSet<UIPress *> *)presses
            withEvent:(UIPressesEvent *)event
// ----------------------------------------------------------------------------
//   Physical key being pressed
// ----------------------------------------------------------------------------
{
    key_push(0);
}


- (void) startBuzzer:(uint) frequency
// ----------------------------------------------------------------------------
//   Start the buzzer
// ----------------------------------------------------------------------------
{
    audio = [[AVAudioEngine alloc] init];
    AVAudioFormat *format = [audio.outputNode outputFormatForBus:0];
    float sampleRate = format.sampleRate;
    float amplitude = 1.0;
    float step = (2*M_PI / 1000) * frequency / sampleRate;

    auto generator = ^OSStatus(BOOL *_Nonnull isSilence,
                               const AudioTimeStamp *_Nonnull timestamp,
                               AVAudioFrameCount frameCount,
                               AudioBufferList *_Nonnull outputData)
    {
        *isSilence = false;
        uint nbuf = outputData->mNumberBuffers;
        for (uint f = 0; f < frameCount; f++)
        {
            float value = amplitude * (self->phase < M_PI ? 1.0 : -1.0);
            self->phase = fmod(self->phase + step, 2 * M_PI);
            for (uint i = 0; i < nbuf; i++)
            {
                AudioBuffer *buf = outputData->mBuffers + i;
                uint nchan = buf->mNumberChannels;
                ASSERT(nchan == 1);
                float *fbuf = (float *) buf->mData;
                fbuf[f] = value;
            }
        }
        return noErr;
    };
    AVAudioSourceNode *source = [[AVAudioSourceNode alloc]
        initWithRenderBlock: generator];

    [audio attachNode:source];
    format = [[AVAudioFormat alloc]
                 initStandardFormatWithSampleRate:sampleRate channels:1];
    [audio connect:source to:[audio mainMixerNode] format:format];
    [audio mainMixerNode].outputVolume = 0.5;

    NSError *error = nil;
    [audio startAndReturnError:&error];
    if (error)
        NSLog(@"AVAudioPlayer error %@", error);
}


- (void) stopBuzzer
// ----------------------------------------------------------------------------
//   Stop the buzzer
// ----------------------------------------------------------------------------
{
    if (audio)
    {
        [audio stop];
        audio = nil;
    }
}


- (void)didReceiveMemoryWarning
// ----------------------------------------------------------------------------
//   Low memory: Dispose of resources that can be recreated
// ----------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


void ui_refresh()
// ----------------------------------------------------------------------------
//   Update the views when they need updating
// ----------------------------------------------------------------------------
{
    if (theViewController)
        [theViewController refresh];
}

uint ui_refresh_count()
// ----------------------------------------------------------------------------
//   Return the number of actual refresh
// ----------------------------------------------------------------------------
{
    if (theViewController)
        return [theViewController refreshCount];
    return 0;
}


    void ui_screenshot()
// ----------------------------------------------------------------------------
//   Save an image from the current screenshot
// ----------------------------------------------------------------------------
{
}


void ui_push_key(int key)
// ----------------------------------------------------------------------------
//   Draw a rectangle indicating we pushed the key
// ----------------------------------------------------------------------------
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [theViewController pushKeyHighlight:key];
    });
}


void ui_ms_sleep(uint delay)
// ----------------------------------------------------------------------------
//   Sleep for the given time
// ----------------------------------------------------------------------------
{
    struct timespec ts;
    ts.tv_sec  = 0;
    ts.tv_nsec = delay * 1000000;
    nanosleep(&ts, nullptr);
}


int ui_file_selector(const char *title,
                     const char *base_dir,
                     const char *ext,
                     file_sel_fn callback,
                     void       *data,
                     int         disp_new,
                     int         overwrite_check)
// ----------------------------------------------------------------------------
//   File selector not implemented on iOS yet
// ----------------------------------------------------------------------------
{
    return 0;
}

void ui_save_setting(const char *name, const char *value)
// ----------------------------------------------------------------------------
//   Saving settings not implemented yet
// ----------------------------------------------------------------------------
{
}


size_t ui_read_setting(const char *name, char *value, size_t maxlen)
// ----------------------------------------------------------------------------
//   Reading settings not implemented yet
// ----------------------------------------------------------------------------
{
    if (strcmp(name, "state") == 0)
    {
        strncpy(value, "state/Demo.48S", maxlen);
        return strlen("state/Demo.48S");
    }
    return 0;
}


uint ui_battery()
// ----------------------------------------------------------------------------
//   Return the battery voltage
// ----------------------------------------------------------------------------
{
    if (!UIDevice.currentDevice.isBatteryMonitoringEnabled)
        UIDevice.currentDevice.batteryMonitoringEnabled = true;

    if (UIDevice.currentDevice.batteryLevel <= 0)
        return 500;
    uint level = uint(1000 * UIDevice.currentDevice.batteryLevel);
    return level;
}


bool ui_charging()
// ----------------------------------------------------------------------------
//   Return true if USB-powered or not
// ----------------------------------------------------------------------------
{
    return UIDevice.currentDevice.batteryState == UIDeviceBatteryStateCharging;
}


void ui_start_buzzer(uint frequency)
// ----------------------------------------------------------------------------
//   Start buzzer at given frequency
// ----------------------------------------------------------------------------
{
    if (theViewController)
        [theViewController startBuzzer:frequency];
}


void ui_stop_buzzer()
// ----------------------------------------------------------------------------
//  Stop buzzer in simulator
// ----------------------------------------------------------------------------
{
    if (theViewController)
        [theViewController stopBuzzer];
}
