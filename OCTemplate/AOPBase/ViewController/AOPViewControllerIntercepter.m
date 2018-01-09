//
//  AOPViewControllerIntercepter.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/26.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "AOPViewControllerIntercepter.h"
#import <UIKit/UIKit.h>
#import <Aspects.h>

@implementation AOPViewControllerIntercepter
+ (void)load {
    [super load];
    [AOPViewControllerIntercepter sharedInstance];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AOPViewControllerIntercepter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AOPViewControllerIntercepter alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        /* 方法拦截 */
        
        // 拦截 viewDidLoad 方法
        [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            
            [self _viewDidLoad:aspectInfo.instance];
        }  error:nil];
        
        // 拦截 viewWillAppear:
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            // 切面 Log
            NSLog(@"View Controller %@ will appear animated: %tu", aspectInfo.instance, animated);

            [self _viewWillAppear:animated controller:aspectInfo.instance];
        } error:NULL];
    }
    return self;
}

#pragma mark - Hook Methods
- (void)_viewDidLoad:(UIViewController <AOPViewControllerProtocol>*)controller {
    if ([controller conformsToProtocol:@protocol(AOPViewControllerProtocol)]) {
        // 只有遵守 FKViewControllerProtocol 的 viewController 才进行 配置
        controller.edgesForExtendedLayout = UIRectEdgeAll;
        controller.extendedLayoutIncludesOpaqueBars = NO;
        controller.automaticallyAdjustsScrollViewInsets = NO;
        
        // 背景色设置为白色
        controller.view.backgroundColor = [UIColor whiteColor];
        
        // 执行协议方法
        [controller rs_initialDefaultsForController];
        [controller rs_bindViewModelForController];
        [controller rs_configNavigationForController];
        [controller rs_createViewForConctroller];
    }
}

- (void)_viewWillAppear:(BOOL)animated controller:(UIViewController <AOPViewControllerProtocol>*)controller {
    
}
@end
