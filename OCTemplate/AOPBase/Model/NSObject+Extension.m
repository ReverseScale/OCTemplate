//
//  NSObject+Extension.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/27.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

static const void *kParamsKey = &kParamsKey;
@implementation NSObject (Extension)
- (void)setParams:(NSDictionary *)params {
    objc_setAssociatedObject(self, kParamsKey, params, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDictionary *)params {
    return objc_getAssociatedObject(self, kParamsKey);
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [self init]) {
        [self setParams:params];
    }
    return self;
}

@end
