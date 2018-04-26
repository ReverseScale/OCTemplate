//
//  TestDataModel.m
//  KYONetWorking
//
//  Created by 张起哲 on 2017/12/6.
//  Copyright © 2017年 Dcamper. All rights reserved.
//

#import "TestDataModel.h"

@implementation TestDataModel

- (instancetype)init{
    self = [super init];
    if (self) {
//        self.userid = userManager.curUserInfo.userid;
//        self.imei = [OpenUDID value].length>32 ? [[OpenUDID value] substringToIndex:32] :[OpenUDID value];
        self.os_type = 2;
//        self.version = [UIApplication sharedApplication].appVersion;
        self.channel = @"App Store";
        self.clientId = self.imei;//[OpenUDID value].length>32 ? [[OpenUDID value] substringToIndex:32] :[OpenUDID value];
//        self.versioncode = KVersionCode;
//        self.mobile_model = [UIDevice currentDevice].machineModelName;
//        self.mobile_brand = [UIDevice currentDevice].machineModel;
    }
    return self;
}

@end
