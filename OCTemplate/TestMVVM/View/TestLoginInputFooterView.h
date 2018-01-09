//
//  TestLoginInputFooterView.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/27.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestLoginButton.h"

@interface TestLoginInputFooterView : UITableViewHeaderFooterView<AOPViewProtocol>
/**
 登录按钮
 */
@property (nonatomic, strong) TestLoginButton *loginBtn;

/**
 查询按钮
 */
@property (nonatomic, strong) UIButton *queryBtn;
@end
