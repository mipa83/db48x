// ****************************************************************************
//  DB48XUITests.m                                                DB48X project
// ****************************************************************************
//
//   File Description:
//
//     User interface tests for DB48X
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

#import <XCTest/XCTest.h>

@interface DB48XUITests : XCTestCase

@end

@implementation DB48XUITests

- (void)setUp
// ----------------------------------------------------------------------------
//   Test setup
// ----------------------------------------------------------------------------
//   This method is called before invokation of each test method in the class
{
    [super setUp];

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test.
    // Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state,
    // such as interface orientation, required for your tests before they run.
    // The setUp method is a good place to do this.
}

- (void)tearDown
// ----------------------------------------------------------------------------
//   Teardown code goes here
// ----------------------------------------------------------------------------
// This method is called after the invocation of each test method
// in the class.
{
    [super tearDown];
}

- (void)testExample
// ----------------------------------------------------------------------------
//   Sample test
// ----------------------------------------------------------------------------
// Use recording to get started writing UI tests.
// Use XCTAssert and related functions to verify your tests produce the
// correct results.
{
}

@end
