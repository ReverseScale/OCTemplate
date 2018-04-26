//
//  OtherViewController.m
//  OCTemplate
//
//  Created by WhatsXie on 2018/4/25.
//  Copyright © 2018年 R.S. All rights reserved.
//

#import "OtherViewController.h"
#import "AutoAlignButtonView.h"

@interface OtherViewController ()<AutoAlignButtonViewDelegate>

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"其他";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupAutoAlignButton];
}

- (void)setupAutoAlignButton {
    AutoAlignButtonView *view = [AutoAlignButtonView new];
    view.dataTitleArray = @[@"深度调用", @"相互跳转", @"组件解耦",@"多平台", @"热修复", @"埋点统计",@"过程监控"];
    view.dataImagesArray = @[@"icon_router_01", @"icon_router_02", @"icon_router_03",@"icon_router_04", @"icon_router_05", @"icon_router_06", @"icon_router_07"];
    view.frame = CGRectMake(0, 100, self.view.bounds.size.width, 0);
    view.isScratchableLatex = YES;
    view.countHorizonal = 3;
    view.delegate = self;
    [self.view addSubview:view];
}

- (void)btnDelegateAction:(UIButton *)button {
    NSLog(@"%@", [NSString stringWithFormat:@"你点击了<%@>",button.titleLabel.text]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
