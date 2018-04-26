//
//  AOPViewIntercepter.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/27.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "AOPViewIntercepter.h"
#import "AOPViewProtocol.h"
#import "Aspects.h"

@implementation AOPViewIntercepter
+ (void)load {
    [AOPViewIntercepter sharedInstance];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AOPViewIntercepter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AOPViewIntercepter alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /* 方法拦截 */
        
        // 代码方式唤起view
        [UIView aspect_hookSelector:@selector(initWithFrame:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo, CGRect frame){
            
            [self _init:aspectInfo.instance withFrame:frame];
        }  error:nil];
        
        // xib方式唤起view
        [UIView aspect_hookSelector:@selector(initWithCoder:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo, NSCoder *aDecoder){
            
            // 在此时 IBOut 中 view 都为空， 需要Hook awakeFromNib 方法
            [self _init:aspectInfo.instance withCoder:aDecoder];
        } error:nil];
        
        // xib方式唤起view
        [UIView aspect_hookSelector:@selector(awakeFromNib) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            
            // 这时候可以初始化视图
            [self _awakFromNib:aspectInfo.instance];
        } error:nil];
    }
    return self;
}

#pragma mark - Hook Methods
- (void)_init:(UIView <AOPViewProtocol>*)view withFrame:(CGRect)frame {
    if ([view respondsToSelector:@selector(rs_initializeForView)]) {
        [view rs_initializeForView];
    }
    
    if ([view respondsToSelector:@selector(rs_createViewForView)]) {
        [view rs_createViewForView];
    }
}

- (void)_init:(UIView <AOPViewProtocol>*)view withCoder:(NSCoder *)aDecoder {
    if ([view respondsToSelector:@selector(rs_initializeForView)]) {
        [view rs_initializeForView];
    }
}

- (void)_awakFromNib:(UIView <AOPViewProtocol>*)view {
    if ([view respondsToSelector:@selector(rs_createViewForView)]) {
        [view rs_createViewForView];
    }
}

@end
