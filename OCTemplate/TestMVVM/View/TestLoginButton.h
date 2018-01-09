//
//  TestLoginButton.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/27.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestLoginButton : UIButton<AOPViewProtocol>

/**
 开始加载动画
 */
- (void)startLoadingAnimation;

/**
 结束加载动画
 */
- (void)stopLoadingAnimation;

@end
