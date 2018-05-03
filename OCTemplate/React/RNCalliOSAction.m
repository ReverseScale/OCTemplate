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

RCT_EXPORT_METHOD(calliOSActionWithSecondParams:(NSString *)params1 params2:(NSString *)params2) {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"参数1：%@\n参数2:%@",params1,params2]];
}

RCT_EXPORT_METHOD(calliOSActionWithDictionParams:(NSDictionary *)diction) {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"参数：%@",diction]];
}

RCT_EXPORT_METHOD(calliOSActionWithArrayParams:(NSArray *)array) {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"参数：%@",array]];
}

RCT_EXPORT_METHOD(calliOSActionWithActionSheet) {
    UIAlertController *sheetView=[UIAlertController alertControllerWithTitle:@"RN Call iOS" message:@"RN调用iOS方法弹出ActionSheet"preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [sheetView addAction:action1];
    
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [sheetView addAction:action2];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:sheetView animated:YES completion:nil];
}

@end
