//
//  ModuleRNPageViewController.m
//  JLRouteTest
//
//  Created by mac on 2017/3/30.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "ReactViewController.h"
#import <React/RCTRootView.h>

@interface ReactViewController ()

@end

@implementation ReactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ReactNative";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupReactNative];
}

- (void)setupReactNative {
    NSURL *jsCodeLocation;

//    jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"];
    jsCodeLocation = [NSURL URLWithString:@"http://10.0.0.65:8081/index.ios.bundle?platform=ios&dev=true"];

    
    RCTRootView *reactRootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"OCTemplate"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    reactRootView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:reactRootView];
    
    UIButton *callReactBtn = [UIButton new];
    callReactBtn.frame = CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 45);
    [callReactBtn setTitle:@"调用 React" forState:UIControlStateNormal];
    [callReactBtn setBackgroundColor:[UIColor redColor]];
    [callReactBtn addTarget:self action:@selector(clickBtnCallReact) forControlEvents:UIControlEventTouchUpInside];
    [reactRootView addSubview:callReactBtn];
}

- (void)clickBtnCallReact {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendName" object:nil userInfo:@{@"name":@"li"}];
}

- (void)dealloc {
    NSLog(@"%@",@"ModuleARNPageViewController dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buttonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
