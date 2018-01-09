//
//  SVProgressHUD+Helper.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (Helper)

/// 显示不带文字的overflow
+ (void)rs_displayOverFlowActivityView;
+ (void)rs_displayOverFlowActivityView:(NSTimeInterval)maxShowTime;

/// 显示成功状态
+ (void)rs_displaySuccessWithStatus:(NSString *)status;

/// 显示失败状态
+ (void)rs_displayErrorWithStatus:(NSString *)status;

/// 显示提示信息
+ (void)rs_dispalyInfoWithStatus:(NSString *)status;

/// 显示提示信息
+ (void)rs_dispalyMsgWithStatus:(NSString *)status;

/// 显示加载圈 加文本
+ (void)rs_dispalyLoadingMsgWithStatus:(NSString *)status;

/// 显示进度，带文本
+ (void)rs_dispalyProgress:(CGFloat)progress status:(NSString *)status;

/// 显示进度，不带文本
+ (void)rs_dispalyProgress:(CGFloat)progress;
@end
