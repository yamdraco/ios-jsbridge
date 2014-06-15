//
//  AsyncTestLibrary.h
//  Cudefield
//
//  Created by Jagarr on 7/6/14.
//  Copyright (c) 2014 Jagarr Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <XCTest/XCTest.h>

@interface AsyncTestLibrary : XCTestCase

@property (nonatomic, assign) int timeout;
@property (nonatomic, assign) BOOL isDone;

- (void) runAsyncTest:(void(^)())testcase;

- (void) done;

@end
