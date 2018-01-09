//
//  AppDelegate.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/26.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import <YTKNetwork.h>
#import "ViewController.h"
#import "TestLoginViewController.h"

NSString *const TestLoginStateChangedNotificationKey = @"TestLoginStateChangedNotificationKey";

@interface AppDelegate()

- (void)configSVProgressHUD;
- (void)configScrollViewAdapt4IOS11;
- (void)configNetworkApiEnv;
- (void)registerNavgationRouter;
- (void)registerSchemaRouter;

// tabbar控制器
@property (nonatomic, strong) UITabBarController *tabbarController;

// 登录控制器
@property (nonatomic, strong) TestLoginViewController *loginController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 普通注册
    [self configSVProgressHUD];
    [self configScrollViewAdapt4IOS11];
    [self configNetworkApiEnv];
    
    // 路由注册
    [self registerNavgationRouter];
    [self registerSchemaRouter];
    
    // 配置根视图控制器
    [self setupRootController];

    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // 默认的路由 跳转等等
    if ([[url scheme] isEqualToString:DefaultRouteSchema]) {
        return [[JLRoutes globalRoutes] routeURL:url];
    }
    // http
    else if ([[url scheme] isEqualToString:HTTPRouteSchema]) {
        return [[JLRoutes routesForScheme:HTTPRouteSchema] routeURL:url];
    }
    // https
    else if ([[url scheme] isEqualToString:HTTPsRouteSchema]) {
        return [[JLRoutes routesForScheme:HTTPsRouteSchema] routeURL:url];
    }
    // Web交互请求
    else if ([[url scheme] isEqualToString:WebHandlerRouteSchema]) {
        return [[JLRoutes routesForScheme:WebHandlerRouteSchema] routeURL:url];
    }
    // 请求回调
    else if ([[url scheme] isEqualToString:ComponentsCallBackHandlerRouteSchema]) {
        return [[JLRoutes routesForScheme:ComponentsCallBackHandlerRouteSchema] routeURL:url];
    }
    // 未知请求
    else if ([[url scheme] isEqualToString:UnknownHandlerRouteSchema]) {
        return [[JLRoutes routesForScheme:UnknownHandlerRouteSchema] routeURL:url];
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
}
- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - Engine
/// 初始化根页面
- (void)setupRootController {
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //注册通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:TestLoginStateChangedNotificationKey object:nil] subscribeNext:^(NSNotification * _Nullable noti) {
        
        NSNumber * number = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
        BOOL isLogin = NO;
        if (number) {
            isLogin = number.boolValue;
        }
        if (isLogin) {
            //已登录
            [self.window setRootViewController:self.tabbarController];
        } else {
            //未登录
            [self.window setRootViewController:self.loginController];
        }
    }];
    
    // 发送一次通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TestLoginStateChangedNotificationKey object:nil];
    
    [self.window makeKeyAndVisible];
}

#pragma mark - Getter
- (UITabBarController *)tabbarController {
    if (!_tabbarController) {
        
        _tabbarController = [[UITabBarController alloc] init];
        
        ViewController *viewController = [[ViewController alloc] init];
        viewController.title = @"示例";
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        navController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_component"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_component_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:kBlcyColor} forState:UIControlStateSelected];
        
        _tabbarController.viewControllers = @[
                                              navController
                                              ];
    }
    return _tabbarController;
}

- (TestLoginViewController *)loginController {
    if (!_loginController) {
        _loginController = [[TestLoginViewController alloc] init];
    }
    return _loginController;
}
@end

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
    config.baseUrl = @"http://www.baidu.com";
    config.cdnUrl = @"http://www.baidu.com";
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
            [currentVC.navigationController pushViewController:toVC animated:YES];
        }
    }
}

/// 获取当前控制器
- (UIViewController *)_currentViewController {
    UIViewController * currVC = nil;
    UIViewController * Rootvc = self.window.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        } else if ([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc != nil);
    return currVC;
}
@end
