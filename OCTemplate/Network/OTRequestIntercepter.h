//
//  FKBaseRequestIntercepter.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTLoginRequest.h"

@interface OTRequestIntercepter : NSObject

- (void)hookRequestArgumentWithInstance:(OTLoginRequest *)request FKDeprecated("Do not use any more");

@end
