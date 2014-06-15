//
//  NSString+Extend.m
//  IOS-JSBridge
//
//  Created by Draco on 17/6/14.
//  Copyright (c) 2014 Draco. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString(Extend)

- (NSString *)stringByDecodingURLFormat {
  NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
  result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  return result;
}

@end
