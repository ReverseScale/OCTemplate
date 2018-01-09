//
//  TestLoginButton.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/27.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "TestLoginButton.h"

@interface TestLoginButton()

@property (nonatomic, strong) UIActivityIndicatorView *loginIndicator;

@end

@implementation TestLoginButton

- (void)rs_createViewForView {
    self.titleLabel.font =  [UIFont systemFontOfSize:17];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.f;
    [self setBackgroundImage:[UIImage imageWithColor:FKTHEMECOLOR] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[FKTHEMECOLOR colorWithAlphaComponent:0.3] ] forState:UIControlStateDisabled];
    [self setTitle:@"登录" forState:UIControlStateNormal];
    // 添加指示器
    [self addSubview:self.loginIndicator];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.loginIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - Public
- (void)startLoadingAnimation {
    [self.loginIndicator startAnimating];
    [self setTitle:@"" forState:UIControlStateNormal];
}

- (void)stopLoadingAnimation {
    [self.loginIndicator stopAnimating];
    [self setTitle:@"登录" forState:UIControlStateNormal];
}

#pragma mark - Getter
- (UIActivityIndicatorView *)loginIndicator {
    if (!_loginIndicator) {
        _loginIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loginIndicator.hidesWhenStopped = YES;
    }
    return _loginIndicator;
}

@end
