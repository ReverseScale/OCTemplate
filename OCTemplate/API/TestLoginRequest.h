//
//  TestLoginRequest.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "OTLoginRequest.h"

/* 大多时候Api只需要一种解析格式，所以此处跟着request走，其他情况下常量字符串建议跟着reformer走， */
// 登录token key
FOUNDATION_EXTERN NSString *TestLoginAccessTokenKey;
// 也可以写成 局部常量形式
static const NSString *TestLoginAccessTokenKey2 = @"accessToken";

@interface TestLoginRequest : OTLoginRequest

- (id)initWithUsr:(NSString *)usr pwd:(NSString *)pwd;

@end
