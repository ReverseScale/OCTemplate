//
//  AutoAlignButtonView.h
//  AutoAlignButton
//
//  Created by StevenXie on 2017/4/26.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSCardButton.h"

@protocol AutoAlignButtonViewDelegate <NSObject>
- (void)btnDelegateAction:(RSCardButton *)button;
@end

@interface AutoAlignButtonView : UIView
@property (nonatomic, strong) NSMutableArray *buttons;

/*
 * 是否九宫格 默认:打开
 */
@property (nonatomic, assign) BOOL isScratchableLatex;
/*
 * 是：自动布局
 *    countHorizonal 九宫格横排数量
 */
@property (nonatomic, assign) NSInteger countHorizonal;
/*
 * 否：参数布局
 *    buttonVerticalPadding 竖向间距
 *    buttonHorizonalPadding 横向间距
 */
@property (nonatomic, assign) CGFloat buttonVerticalPadding;
@property (nonatomic, assign) CGFloat buttonHorizonalPadding;

/*
 * 是否开启圆角 默认:关闭 打开后根据需要设置圆角参数（离屏渲染待优化）
 */
@property (nonatomic, assign) BOOL isCornerRadius;


// 数据源 （必选方法）
@property (nonatomic, copy) NSArray *dataTitleArray;
@property (nonatomic, copy) NSArray *dataImagesArray;

// 点击事件delegate
@property (nonatomic, weak) id<AutoAlignButtonViewDelegate> delegate;


@end
