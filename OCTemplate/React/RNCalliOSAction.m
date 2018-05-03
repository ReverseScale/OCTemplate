//
//  RNCalliOSAction.m
//  OCTemplate
//
//  Created by WhatsXie on 2018/5/3.
//  Copyright © 2018年 R.S. All rights reserved.
//

#import "RNCalliOSAction.h"
#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "RCSubEventEmitter.h"

#import <React/RCTEventDispatcher.h>

@implementation RNCalliOSAction

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(calliOSActionWithOneParams:(NSString *)name) {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"参数：%@",name]];
}


@end
