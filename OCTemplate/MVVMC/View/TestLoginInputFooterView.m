//
//  TestLoginInputFooterView.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/27.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "TestLoginInputFooterView.h"

@implementation TestLoginInputFooterView

- (void)rs_createViewForView {
    [self addSubview:self.loginBtn];
    [self addSubview:self.queryBtn];
}

#pragma mark - Layout
- (void)updateConstraints {
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self.queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.loginBtn);
        make.size.mas_equalTo(self.loginBtn);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(10);
    }];
    
    [super updateConstraints];
}

#pragma mark - Getter
- (TestLoginButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[TestLoginButton alloc] initWithFrame_rs:CGRectZero];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}

- (UIButton *)queryBtn {
    if (!_queryBtn) {
        _queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_queryBtn setTitle:@"登录遇到问题？" forState:UIControlStateNormal];
        [_queryBtn setTitleColor:FKTHEMECOLOR forState:UIControlStateNormal];
        _queryBtn.titleLabel.font =  [UIFont systemFontOfSize:17];
    }
    return _queryBtn;
}
@end
