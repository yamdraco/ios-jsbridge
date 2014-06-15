//
//  JSBridgeRequest.h
//  IOS-JSBridge
//
//  Created by Draco on 14/6/14.
//  Copyright (c) 2014 Draco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessCallback)(NSArray*);
typedef void(^FailCallback)(NSError*);

@interface JSBridgeRequest : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *fun;
@property (nonatomic, strong) NSString *params;

@property (nonatomic, copy) SuccessCallback successCallback;
@property (nonatomic, copy) FailCallback failCallback;
@property (nonatomic, strong) NSDate *requestTime;

@end
