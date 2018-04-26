//
//  AOPViewModelIntercepter.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/27.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "AOPViewModelIntercepter.h"
#import "NSObject+Extension.h"
#import "AOPViewModelProtocol.h"
#import "Aspects.h"

@implementation AOPViewModelIntercepter
+ (void)load {
    [super load];
    [AOPViewModelIntercepter sharedInstance];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AOPViewModelIntercepter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AOPViewModelIntercepter alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /* 方法拦截 */
        
        [NSObject aspect_hookSelector:@selector(initWithParams:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo, NSDictionary *param){
            
            [self _initWithInstance:aspectInfo.instance params:param];
        } error:nil];
    }
    return self;
}

#pragma mark - Hook Methods
- (void)_initWithInstance:(NSObject <AOPViewModelProtocol> *)viewModel {
    if ([viewModel respondsToSelector:@selector(rs_initializeForViewModel)]) {
        [viewModel rs_initializeForViewModel];
    }
}

- (void)_initWithInstance:(NSObject <AOPViewModelProtocol> *)viewModel params:(NSDictionary *)param {
    if ([viewModel respondsToSelector:@selector(rs_initializeForViewModel)]) {
        [viewModel rs_initializeForViewModel];
    }
}
@end
