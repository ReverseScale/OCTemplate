//
//  RouterConstant.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouterConstant : NSObject

// 路由默认控制器参数名
FOUNDATION_EXTERN NSString *const ControllerNameRouteParam;

#pragma mark - 路由模式 Schema
/**
 模式 Native：AppSchema://url/:param
 */
// 默认路由
FOUNDATION_EXTERN NSString *const DefaultRouteSchema;

// 网络跳转路由模式
FOUNDATION_EXTERN NSString *const HTTPRouteSchema;
FOUNDATION_EXTERN NSString *const HTTPsRouteSchema;

// WEB交互路由跳转模式
FOUNDATION_EXTERN NSString *const WebHandlerRouteSchema;

// 回调通信
FOUNDATION_EXTERN NSString *const ComponentsCallBackHandlerRouteSchema;

// 未知路由
FOUNDATION_EXTERN NSString *const UnknownHandlerRouteSchema;


#pragma mark - 路由表
// 导航栏 Push
FOUNDATION_EXTERN NSString *const NavPushRoute;

// 导航栏 Present
FOUNDATION_EXTERN NSString *const NavPresentRoute;

// StoryBoard Push
FOUNDATION_EXTERN NSString *const NavStoryBoardPushRoute;

// 组件通信回调
FOUNDATION_EXTERN NSString *const ComponentsCallBackRoute;
@end
