//
//  OtherViewController.m
//  OCTemplate
//
//  Created by WhatsXie on 2018/4/25.
//  Copyright © 2018年 R.S. All rights reserved.
//

#import "OtherViewController.h"
#import "AutoAlignButtonView.h"
#import "TestDataRequest.h"

@interface OtherViewController ()<AutoAlignButtonViewDelegate>
@property (nonatomic, strong) TestDataRequest *testDataRequest;
@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"其他";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupAutoAlignImageButton];
    
    _testDataRequest = [[TestDataRequest alloc] initWithPage:1 pageSize:10];
}

- (void)setupAutoAlignImageButton {
    AutoAlignButtonView *view = [AutoAlignButtonView new];
    view.dataTitleArray = @[@"深度调用", @"相互跳转", @"组件解耦",
                            @"多平台", @"热修复", @"埋点统计",
                            @"过程监控", @"", @"",
                            @"|请求|", @"|翻页|",@"|缓存|",
                            ];
    view.dataImagesArray = @[@"icon_router_01", @"icon_router_02", @"icon_router_03",
                             @"icon_router_04", @"icon_router_05", @"icon_router_06",
                             @"icon_router_07", @"", @"",
                             @"", @"", @"",
                             ];
    view.frame = CGRectMake(0, 100, self.view.bounds.size.width, 0);
    view.isScratchableLatex = YES;
    view.countHorizonal = 3;
    view.delegate = self;
    [self.view addSubview:view];
}

#pragma mark - Network
// YTKNetwork 使用示例(待优化)
- (void)testDataGETRequest {
    [_testDataRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",_testDataRequest.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"failed");
    }];
}

- (void)testDataCache {
    // 判断是否本地缓存
    if ([_testDataRequest loadCacheWithError:nil]) {
        NSDictionary *json = [_testDataRequest responseJSONObject];
        NSLog(@"cachJson = %@", json);
    } else {
        [self testDataRequest];
    }
}

#pragma mark - Action
- (void)btnDelegateAction:(UIButton *)button {
    NSLog(@"%@", [NSString stringWithFormat:@"你点击了<%@>",button.titleLabel.text]);
    
    [self handleTestWithAction:button];
}

- (void)handleTestWithAction:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"|请求|"]) {
        [_testDataRequest resetPage];
        [self testDataGETRequest];
    } else if ([button.titleLabel.text isEqualToString:@"|翻页|"]) {
        [_testDataRequest loadNextPage];
        [self testDataGETRequest];
    } else if ([button.titleLabel.text isEqualToString:@"|缓存|"]) {
        [self testDataCache];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
