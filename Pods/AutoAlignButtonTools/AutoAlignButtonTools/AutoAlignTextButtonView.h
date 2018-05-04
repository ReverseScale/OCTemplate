//
//  AutoAlignTextButtonView.h
//  AutoAlignButton
//
//  Created by WhatsXie on 2017/7/13.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AutoAlignTextButtonViewDelegate <NSObject>
- (void)btnDelegateAction:(UIButton *)button;
@end

@interface AutoAlignTextButtonView : UIView{
    NSMutableArray *_buttons;
}
// 数据
@property (nonatomic, copy) NSArray *dataArray;
// 布局参数
@property (nonatomic, assign) CGFloat buttonVerticalPadding; // 竖向间距
@property (nonatomic, assign) CGFloat buttonHorizonalPadding; // 横向间距
// 点击事件delegate
@property (nonatomic, weak) id<AutoAlignTextButtonViewDelegate> delegate;
@end
