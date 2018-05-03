//
//  RCSubEventEmitter.m
//  OCTemplate
//
//  Created by WhatsXie on 2018/5/3.
//  Copyright © 2018年 R.S. All rights reserved.
//

#import "RCSubEventEmitter.h"

@implementation RCSubEventEmitter

- (NSArray<NSString *> *)supportedEvents {
    return @[@"Callback"];
}

- (void)Callback:(NSString*)code result:(NSString*) result {
    [self sendEventWithName:@"Callback"
                       body:@{
                              @"code": code,
                              @"result": result,
                              }];
}
@end
