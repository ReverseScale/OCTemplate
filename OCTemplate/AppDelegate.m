//
//  AppDelegate.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/26.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Extension.h"

NSString *const TestLoginStateChangedNotificationKey = @"TestLoginStateChangedNotificationKey";

NSString *const ViewController_login = @"LoginViewController";
NSString *const ViewController_example = @"ExampleViewController";
NSString *const ViewController_other = @"OtherViewController";

NSString *const Title_example = @"示例";
NSString *const Title_other = @"其他";

NSString *const icon_example = @"icon_tabbar_component";
NSString *const icon_example_selected = @"icon_tabbar_component_selected";

NSString *const Icon_other = @"icon_tabbar_lab";
NSString *const Icon_other_selected = @"icon_tabbar_lab_selected";

NSString *const Key_login_save = @"isLogin";

@interface AppDelegate()
@property (nonatomic, strong) UITabBarController *tabbarController;
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
        
        NSNumber * number = [[NSUserDefaults standardUserDefaults] objectForKey:Key_login_save];
        BOOL isLogin = NO;
        if (number) {
            isLogin = number.boolValue;
        }
        if (isLogin) {
            //已登录
            [self.window setRootViewController:self.tabbarController];
        } else {
            //未登录
            [self.window setRootViewController:[[NSClassFromString(ViewController_login) alloc] init]];
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
        
        UINavigationController *navController = [self getNavigationControllerWithViewController:[[NSClassFromString(ViewController_example) alloc] init] title:Title_example tabBarItemImageName:icon_example tabBarItemSelectedImageName:icon_example_selected];
        
        UINavigationController *navOtherController = [self getNavigationControllerWithViewController:[[NSClassFromString(ViewController_other) alloc] init] title:Title_other tabBarItemImageName:Icon_other tabBarItemSelectedImageName:Icon_other_selected];
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:kBlcyColor} forState:UIControlStateSelected];
        
        _tabbarController.viewControllers = @[
                                              navController,
                                              navOtherController,
                                              ];
    }
    return _tabbarController;
}

- (UINavigationController *)getNavigationControllerWithViewController:(UIViewController *)viewControlle
                                                                title:(NSString *)title
                                                  tabBarItemImageName:(NSString *)imageName
                                          tabBarItemSelectedImageName:(NSString *)selectedImageName {
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewControlle];
    navController.title = title;
    navController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return navController;
}
@end
