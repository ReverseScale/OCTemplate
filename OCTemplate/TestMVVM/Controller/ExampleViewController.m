//
//  ViewController.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/26.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "ExampleViewController.h"
#import "SVProgressHUD+Helper.h"
#import "AppDelegate.h"
//#import "PushViewController.h" //通过路由控制，就不需要引用要跳转的控制器了

@interface ExampleViewController ()
// 退出登录
@property (nonatomic, strong) UIButton *logoutBtn;

// 跳转
@property (nonatomic, strong) UIButton *pushBtn;
@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"示例";

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter
- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutBtn.layer.cornerRadius = 10;
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _logoutBtn.backgroundColor = kRecyColor;
        [_logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _logoutBtn;
}

- (UIButton *)pushBtn {
    if (!_pushBtn) {
        _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushBtn setTitle:@"进下一页" forState:UIControlStateNormal];
        _pushBtn.layer.cornerRadius = 10;
        _pushBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _pushBtn.backgroundColor = klightBlcyColor;
        [_pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _pushBtn;
}

#pragma mark - Layout
- (void)updateViewConstraints {
    // 更新约束
    NSArray *views = @[self.pushBtn, self.logoutBtn];
    CGFloat offset = SCREEN_HEIGHT/2;
    
    /* 等间隔排列 - 多个控件间隔固定，控件长度/宽度变化
     * withFixedItemLength: 控件高度
     * leadSpacing: 距顶部距离
     * tailSpacing: 距底部距离
     */
    [views mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:80 leadSpacing:offset tailSpacing:offset];

    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}

/// 绑定 vm
- (void)rs_bindViewModelForController {
    // push
    [[self.pushBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        // 路由链接
        
//        NSString *router = [JLRoutes rs_generateURLWithPattern:NavPushRoute parameters:@[@"PushViewController"]];
        
        NSString *routerDetail = [JLRoutes rs_generateURLWithPattern:NavPushRoute parameters:@[@"ReactViewController"] extraParameters:@{@"key":@"value"}];
        
        [[RACScheduler mainThreadScheduler] schedule:^{
//            OCTemplate://com_R_S_navPush/PushViewController?key=value
            // 路由跳转
            [[UIApplication sharedApplication] openURL:JLRGenRouteURL(DefaultRouteSchema, routerDetail)];
        }];
    }];
    
    // logout
    [[self.logoutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"isLogin"];
        [SVProgressHUD rs_dispalyMsgWithStatus:@"2秒后将退出登录"];
        [SVProgressHUD dismissWithDelay:2.0f completion:^{
            NSLog(@"2秒后将退出登录");
            // 通知操作
            [[NSNotificationCenter defaultCenter] postNotificationName:TestLoginStateChangedNotificationKey object:nil];
        }];
    }];
}
/// 配置导航栏
- (void)rs_configNavigationForController {
    
}
/// 创建视图
- (void)rs_createViewForConctroller {
    [self.view addSubview:self.logoutBtn];
    [self.view addSubview:self.pushBtn];
    
    [self.view setNeedsUpdateConstraints];
}
/// 初始化数据
- (void)rs_initialDefaultsForController {
    
}

@end
