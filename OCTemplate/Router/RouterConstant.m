//
//  RouterConstant.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "RouterConstant.h"

NSString *const ControllerNameRouteParam = @"viewController";

#pragma mark - 路由模式
NSString *const DefaultRouteSchema = @"OCTemplate";
NSString *const HTTPRouteSchema = @"http";
NSString *const HTTPsRouteSchema = @"https";

NSString *const ComponentsCallBackHandlerRouteSchema = @"AppCallBack";
NSString *const WebHandlerRouteSchema = @"Custom";
NSString *const UnknownHandlerRouteSchema = @"UnKnown";

#pragma mark - 路由表
NSString *const NavPushRoute = @"/com_R_S_navPush/:viewController";
NSString *const NavPresentRoute = @"/com_R_S_navPresent/:viewController";
NSString *const NavStoryBoardPushRoute = @"/com_R_S_navStoryboardPush/:viewController";
NSString *const ComponentsCallBackRoute = @"/com_R_S_callBack/*";
