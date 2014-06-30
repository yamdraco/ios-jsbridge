//
//  JSBridge.m
//  IOS-JSBridge
//
//  Created by Draco on 13/6/14.
//  Copyright (c) 2014 Draco. All rights reserved.
//

#import "JSBridge.h"

#import "JSBridgeRequest.h"

@interface JSBridge() {

  NSMutableDictionary *requests; // Request in the progress
  NSMutableDictionary *timers;   // timers to call timeout
  
  int keyCounter;                // key to identify each connection
  
  NSMutableArray *queue;         // queue to make request
  
}

- (void) runSuccessCallback:(NSArray*)result withKey:(NSString*)key;
- (void) runFailCallback:(NSError*)error withKey:(NSString*)key;
- (void) cancelTimeoutWithKey:(NSString*)key;
- (void) addTimeoutWithKey:(NSString*)key;

@end

@implementation JSBridge

@synthesize webview, isReady;

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(JSBridge);

- (id) init {
  self = [super init];
  requests = [[NSMutableDictionary alloc]init];
  timers = [[NSMutableDictionary alloc]init];
	
  webview = [[UIWebView alloc]init];
  NSURL *htmlFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"empty" ofType:@"html"] isDirectory:NO];
  [webview loadRequest:[NSURLRequest requestWithURL:htmlFile]];
  webview.delegate = self;
  keyCounter = 1;
  
  isReady = NO;
  
  queue = [[NSMutableArray alloc]init];
  
  return self;
}

#pragma mark -
#pragma mark JS
- (NSString*)runJs:(NSString*)jsStr {
  return [webview stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)runAsyncJs:(NSString *)fun success:(void(^)(NSArray*))successCallback fail:(void(^)(NSError*))failCallback {
  [self runAsyncJs:fun param:nil success:successCallback fail:failCallback];
}

- (void)runAsyncJs:(NSString *)fun param:(NSString*)params success:(void(^)(NSArray*))successCallback fail:(void(^)(NSError*))failCallback {

  // Create unique
  NSString *key = [NSString stringWithFormat:@"%d", keyCounter];
  keyCounter++;
  
  if (!params)
    params = @"{}";
  
  // Make JSBridgeRequest Obj and stored
  JSBridgeRequest *req = [[JSBridgeRequest alloc]init];
  req.key = key;
  req.fun = fun;
  req.params = params;
  req.successCallback = successCallback;
  req.failCallback = failCallback;
  req.requestTime = [NSDate date];
  requests[key] = req;
  [queue addObject:req];
  
  [self runAsyncJs];
}

- (void) runAsyncJs {
  if (isReady && [queue count] > 0) {
    JSBridgeRequest *req = [queue objectAtIndex:0];
    [queue removeObjectAtIndex:0];
    // Add timeout with Key
    [self addTimeoutWithKey:req.key];
    
    // Run javascript
    if (!req.params || [req.params isEqualToString:@""]) {
      req.params = @"''";
    }
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@', %@)", req.fun, req.key, req.params]];
    [self runAsyncJs];
  }
}


#pragma mark -
#pragma mark private function
- (void) runSuccessCallback:(NSArray*)result withKey:(NSString*)key {
  [self cancelTimeoutWithKey:key];
  if (requests[key]) {
    ((JSBridgeRequest*)requests[key]).successCallback(result);
    [requests removeObjectForKey:key];
  }
}

- (void) runFailCallback:(NSError*)error withKey:(NSString*)key {
  // TODO: may wanna cancel javascript
  ((JSBridgeRequest*)requests[key]).failCallback(error);
  [requests removeObjectForKey:key];
  [timers removeObjectForKey:key];
}

- (void) cancelTimeoutWithKey:(NSString*)key {
  NSTimer *timer = timers[key];
  [timer invalidate];
  [timers removeObjectForKey:key];
}

- (void) addTimeoutWithKey:(NSString*)key {
  NSTimer *timer = [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(asyncTimeout:) userInfo:key repeats:NO];
  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
  timers[key] = timer;
}

#pragma mark -
#pragma mark NSTimeoutDelegate
- (void) asyncTimeout:(NSTimer*)timer {
  NSError *error = [NSError errorWithDomain:@"Async Operation timeout" code:504 userInfo:@{}];
  [self runFailCallback:error withKey:timer.userInfo];
}

#pragma mark -
#pragma mark UIWebviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSString *scheme = [[request URL] scheme];
  NSString *host = [[request URL] host];
  NSArray *components = [[request URL] pathComponents];
  NSArray *array = [components subarrayWithRange:NSMakeRange(1, [components count]-1)];

  if ([scheme isEqualToString:@"js"]) {
    if ([host isEqualToString:@"log"]) {
      NSLog(@"%@", components[1]);
    } else if (requests[host]) {
      NSArray *array = [components subarrayWithRange:NSMakeRange(1, [components count]-1)];
      [self runSuccessCallback:array withKey:host];
    } else {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"JSBridgeNotification" object:self userInfo:@{@"host": host, @"components": array}];
    }
    
    return NO;
  }
  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  isReady = YES;
  [self runAsyncJs];
}



@end
