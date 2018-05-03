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

RCT_EXPORT_METHOD(calliOSActionWithCallBack:(RCTResponseSenderBlock)callBack) {
    NSString *string = @"hi";
    NSArray *array = @[@"RN",@"and",@"iOS"];
    NSString *end = @"welcome";
    
    callBack(@[string,array,end]);
}

RCT_EXPORT_METHOD(calliOSActionWithResolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    NSString *string=@"Hello RN and iOS";
    if (string) {
        /*
         * 正确回调，传递参数
         * typedef void (^RCTPromiseResolveBlock)(id result);
         */
        resolve(string);
    } else {
        NSError *error=[NSError errorWithDomain:@"errorMsg" code:101 userInfo:nil];
        /*
         * 错误回调，传三个参数
         * typedef void (^RCTPromiseRejectBlock)(NSString *code, NSString *message, NSError *error);
         */
        reject(@"code",@"message",error);
    }
}

RCT_EXPORT_METHOD(RNCalliOSToShowDatePicker) {
    /*
     * 耗时操作在子线程中完成
     * dispatch_sync(dispatch_queue_create(@"com.RNCalliOS.queue", NULL), ^{
     });
     */
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIDatePicker *picker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 216)];
        picker.tag=100;
        picker.date=[NSDate date];
        picker.datePickerMode=UIDatePickerModeDateAndTime;
        picker.backgroundColor=[UIColor whiteColor];
        
        NSDate* minDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-24*60*60*10];
        picker.minimumDate=minDate;
        picker.maximumDate=[NSDate date];
        
        [picker addTarget:self action:@selector(dateChane:) forControlEvents:UIControlEventValueChanged];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:picker];
        
        UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 44)];
        topView.tag=101;
        topView.backgroundColor=[UIColor lightGrayColor];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:topView];
        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(topView.frame.size.width-60, 0, 60, 44)];
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topView addSubview:button];
        
        [UIView animateWithDuration:.25 animations:^{
            picker.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-216, [UIScreen mainScreen].bounds.size.width, 216);
            topView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-216-44, [UIScreen mainScreen].bounds.size.width, 44);
        }];
    });
}

- (void)dateChane:(UIDatePicker *)picker {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *str_date = [formatter stringFromDate:picker.date];
    [self.bridge.eventDispatcher sendAppEventWithName:@"getSelectDate" body:@{@"SelectDate":str_date}];
}

- (void)dismissView {
    UIDatePicker *picker=(UIDatePicker *)[[UIApplication sharedApplication].keyWindow.rootViewController.view viewWithTag:100];
    UIDatePicker *topview=(UIDatePicker *)[[UIApplication sharedApplication].keyWindow.rootViewController.view viewWithTag:101];
    
    [UIView animateWithDuration:.25 animations:^{
        picker.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 216);
        topview.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 44);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [picker removeFromSuperview];
            [topview removeFromSuperview];
        }
    }];
}


RCT_EXPORT_METHOD(RNCalliOSToConstantsToExport) {
    RCSubEventEmitter *emitter=[[RCSubEventEmitter alloc]init];
    [emitter Callback:@"123" result:@"456"];
}

- (NSDictionary *)constantsToExport {
    return @{@"age":@"18",
             @"sex":@"男",
             @"job":@"IT",
             @"tel":@"123456789"};
}

@end
