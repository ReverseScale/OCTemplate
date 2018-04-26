//
//  NSObject+Extension.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/27.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)
/**
 去表征化参数列表
 */
@property (nonatomic, strong, readonly) NSDictionary *params;

/**
 初始化方法
 */
- (instancetype)initWithParams:(NSDictionary *)params;
@end
