//
//  IOS_JSBridgeTests.m
//  IOS-JSBridgeTests
//
//  Created by Draco on 13/6/14.
//  Copyright (c) 2014 Draco. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "JSBridge.h"

#import "AsyncTestLibrary.h"

@interface IOS_JSBridgeTests : XCTestCase

@end

@implementation IOS_JSBridgeTests

- (void)setUp {
  [super setUp];
  NSString *path = [[NSBundle mainBundle]pathForResource:@"build" ofType:@"js"];
  NSString *txtFileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
  [JS.webview stringByEvaluatingJavaScriptFromString:txtFileContents];
}

- (void)tearDown{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testTimeout {
  AsyncTestLibrary *test = [[AsyncTestLibrary alloc]init];
  AsyncTestLibrary __weak *_test = test;
  test.timeout = 60000;
  [test runAsyncTest:^() {
    [JS runAsyncJs:@"app.test_async" param:@"{}" success:^(NSArray *result) {
      XCTAssertEqualObjects(result, nil);
      [_test done];
    } fail:^(NSError *err) {
      XCTAssertEqual(err.code, 504);
      [_test done];
    }];
  }];
  XCTAssertEqual(_test.isDone, YES, @"Async function timeout");
}

- (void)testAsyncCalls {
  AsyncTestLibrary *test = [[AsyncTestLibrary alloc]init];
  AsyncTestLibrary __weak *_test = test;
  test.timeout = 60000;
  [test runAsyncTest:^() {
    [JS runAsyncJs:@"app.test_async" param:@"{_timeout: 2000}" success:^(NSArray *result){
      XCTAssertEqualObjects(@"{\"status\":200,\"message\":\"\",\"results\":{\"async\":\"test passed\"}}", result[0]);
      [_test done];
    } fail:^(NSError* err) {
      XCTAssertEqualObjects(err, nil);
      [_test done];
    }];
  }];
  XCTAssertEqual(_test.isDone, YES, @"Async function timeout");
}

@end
