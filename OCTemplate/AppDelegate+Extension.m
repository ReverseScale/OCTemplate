//
//  AppDelegate+Extension.m
//  OCTemplate
//
//  Created by WhatsXie on 2018/4/25.
//  Copyright © 2018年 R.S. All rights reserved.
//

#import "AppDelegate+Extension.h"
#import "OTUrlArgumentsFilter.h"
#import <WebKit/WebKit.h>
#import <YTKNetwork.h>

#pragma mark - 初始化 SVProgressHUD 配置
@implementation AppDelegate(SVProgressHUD)

- (void)configSVProgressHUD {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.85f]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setRingThickness:4];
    [SVProgressHUD setMinimumSize:CGSizeMake(60, 60)];
}
@end

#pragma mark - IOS11适配
@implementation AppDelegate(Adapt4IOS11)

- (void)configScrollViewAdapt4IOS11 {
    if (IOS11_OR_LATER) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UIWebView appearance].scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [WKWebView appearance].scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
    }
}
@end

#pragma mark - YTKNetworking 接口地址配置
@implementation AppDelegate(NetworkApiEnv)

- (void)configNetworkApiEnv {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    if (DEBUG) {
        config.debugLogEnabled = YES;
    } else {
        config.debugLogEnabled = NO;
    }

    config.baseUrl = @"http://www.dcamp.com";
    config.cdnUrl = @"http://fen.bi";
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    OTUrlArgumentsFilter *urlFilter = [OTUrlArgumentsFilter filterWithArguments:@{@"version": appVersion}];
    [config addUrlFilter:urlFilter]; 
}
@end

#pragma mark - 路由注册
@implementation AppDelegate(RouterRegister)

#pragma mark - 普通的跳转路由注册
- (void)registerNavgationRouter {
    // push
    // 路由 /com_madao_navPush/:viewController
    [[JLRoutes globalRoutes] addRoute:NavPushRoute handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _handlerSceneWithPresent:NO parameters:parameters];
        });
        return YES;
    }];
    
    // present
    // 路由 /com_madao_navPresent/:viewController
    [[JLRoutes globalRoutes] addRoute:NavPresentRoute handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _handlerSceneWithPresent:YES parameters:parameters];
        });
        return YES;
    }];
    
    // sb push
    // 路由 /com_madao_navStoryboardPush/:viewController
    [[JLRoutes globalRoutes] addRoute:NavStoryBoardPushRoute handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        return YES;
    }];
}

#pragma mark - Schema 匹配
- (void)registerSchemaRouter {
    // HTTP注册
    [[JLRoutes routesForScheme:HTTPRouteSchema] addRoute:@"/somethingHTTP" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        return NO;
    }];
    // HTTPS注册
    [[JLRoutes routesForScheme:HTTPsRouteSchema] addRoute:@"/somethingHTTPs" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        return NO;
    }];
    // 自定义 Schema注册
    [[JLRoutes routesForScheme:WebHandlerRouteSchema] addRoute:@"/somethingCustom" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        return NO;
    }];
}

#pragma mark - Private
/// 处理跳转事件
- (void)_handlerSceneWithPresent:(BOOL)isPresent parameters:(NSDictionary *)parameters {
    // 当前控制器
    NSString *controllerName = [parameters objectForKey:ControllerNameRouteParam];
    UIViewController *currentVC = [self _currentViewController];
    UIViewController *toVC = [[NSClassFromString(controllerName) alloc] init];
    toVC.params = parameters;
    if (currentVC && currentVC.navigationController) {
        if (isPresent) {
            [currentVC.navigationController presentViewController:toVC animated:YES completion:nil];
        } else {
            toVC.hidesBottomBarWhenPushed = YES;
            [currentVC.navigationController pushViewController:toVC animated:YES];
        }
    }
}

/// 获取当前控制器
- (UIViewController *)_currentViewController {
    UIViewController * currentVC = nil;
    UIViewController * rootVC = self.window.rootViewController ;
    do {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)rootVC;
            UIViewController * vc = [nav.viewControllers lastObject];
            currentVC = vc;
            rootVC = vc.presentedViewController;
            continue;
        } else if ([rootVC isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)rootVC;
            currentVC = tabVC;
            rootVC = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (rootVC != nil);

    return currentVC;
}
@end
