//
//  TestLoginRequest.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "TestLoginRequest.h"

// 登录token key
NSString *TestLoginAccessTokenKey = @"accessToken";

@implementation TestLoginRequest {
    NSString *_usr;
    NSString *_pwd;
}

- (id)initWithUsr:(NSString *)usr pwd:(NSString *)pwd {
    self = [super init];
    if (self) {
        _usr = usr;
        _pwd = pwd;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}

- (BOOL)statusCodeValidator {
    return YES;
}

/**
 可以在这里对response 数据进行重新格式化， 也可以使用delegate 设置 reformattor

 @param jsonResponse id jsonResponse
 @return id JSONResponse
 */
//- (id)reformJSONResponse:(id)jsonResponse
//{
//
//}

- (NSString *)requestUrl {
    return @"";
}


- (id)requestArgument {
    return  @{
              @"username":_usr,
              @"password":_pwd,
              };
}

@end
