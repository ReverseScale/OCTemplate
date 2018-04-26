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
    jsCodeLocation = [NSURL URLWithString:@"http://10.0.0.65:8081/index.ios.bundle?platform=ios&dev=true"];
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"OCTemplate"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    //注意，这里是 @"EmbedRNMeituan"
    rootView.frame = CGRectMake(0, 64, 300, 300);
    [self.view addSubview:rootView];
}

- (void)dealloc {
    NSLog(@"%@",@"ModuleARNPageViewController dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
