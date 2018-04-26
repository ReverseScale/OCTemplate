//
//  UIViewController+Extension.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/27.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOPViewControllerProtocol.h"
@interface UIViewController (Extension)

/**
 去Model&&表征化参数列表
 */
@property (nonatomic, strong) NSDictionary *params;

/**
 ViewModel 属性
 */
@property (nonatomic, strong) id <AOPViewControllerProtocol> viewModel;

#pragma mark - 通用类

/**
 返回Controller的当前bounds
 
 @param hasNav 是否有导航栏
 @param hasTabBar 是否有tabbar
 @return 坐标
 */
- (CGRect)rs_visibleBoundsShowNav:(BOOL)hasNav showTabBar:(BOOL)hasTabBar;

/**
 隐藏键盘
 */
- (void)rs_hideKeyBoard;

@end
