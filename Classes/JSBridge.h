//
//  JSBridge.h
//  IOS-JSBridge
//
//  Created by Draco on 13/6/14.
//  Copyright (c) 2014 Draco. All rights reserved.
//

#import <Foundation/Foundation.h>

// Library
#import "CWLSynthesizeSingleton.h"

@interface JSBridge : NSObject <UIWebViewDelegate>

#define JS ([JSBridge sharedJSBridge])
CWL_DECLARE_SINGLETON_FOR_CLASS(JSBridge)

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, assign) BOOL isReady;   // Js should only be loaded in when the webview is ready

/**
 * Perform javascript
 * @param jsStr
 * @param return
 */
- (NSString*)runJs:(NSString*)jsStr;

/**
 * Make async call to the javascript function without parameters
 * @param fun, function name
 * @param successCallback, if the bridge is connected, this would be called
 * @param failCallback, if the bridge hits timeout, this would be called
 */
- (void)runAsyncJs:(NSString *)fun success:(void(^)(NSArray*))successCallback fail:(void(^)(NSError*))failCallback;

/**
 * Make async call to the javascript function
 * @param fun, function name
 * @param param, parameter to call
 * @param successCallback, if the bridge is connected, this would be called
 * @param failCallback, if the bridge hits timeout, this would be called
 */
- (void)runAsyncJs:(NSString *)fun param:(NSString*)param success:(void(^)(NSArray*))successCallback fail:(void(^)(NSError*))failCallback;

@end