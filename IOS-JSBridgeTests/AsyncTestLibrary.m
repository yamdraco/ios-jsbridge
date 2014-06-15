//
//  AsyncTestLibrary.m
//  Cudefield
//
//  Created by Jagarr on 7/6/14.
//  Copyright (c) 2014 Jagarr Limited. All rights reserved.
//

#import "AsyncTestLibrary.h"

@implementation AsyncTestLibrary

@synthesize timeout, isDone;

- (id) init {
  self = [super init];
  timeout = 4000;
  isDone = NO;
  return self;
}

- (void) runAsyncTest:(void(^)())testcase {
  
  testcase();
  int counter = self.timeout;
  while (!isDone && counter > 0) {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    counter--;
  }
}

- (void) done {
  isDone = YES;
}

@end
