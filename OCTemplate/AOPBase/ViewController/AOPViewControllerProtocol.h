//
//  AOPViewControllerProtocol.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/26.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 为 ViewController 绑定方法协议
 */
@protocol AOPViewControllerProtocol <NSObject>

#pragma mark - 方法绑定
@required
/// 初始化数据
- (void)rs_initialDefaultsForController;

/// 绑定 vm
- (void)rs_bindViewModelForController;

/// 创建视图
- (void)rs_createViewForConctroller;

/// 配置导航栏
- (void)rs_configNavigationForController;

@end
