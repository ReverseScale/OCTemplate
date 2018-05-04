//
//  AutoAlignTextButtonView.m
//  AutoAlignButton
//
//  Created by WhatsXie on 2017/7/13.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "AutoAlignTextButtonView.h"

@implementation AutoAlignTextButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [NSArray array];
        _buttons = [NSMutableArray array];
        self.buttonVerticalPadding = 15.0;
        self.buttonHorizonalPadding = 14.0;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (NSString *title in self.dataArray) {
        UIButton *button = [self createButtonWithTitle:title];
        CGRect buttonFrame = button.frame;
        CGFloat buttonWidth = [self buttonWidthForButton:button];
        buttonFrame.size.width = buttonWidth;
        button.frame = buttonFrame;
        [_buttons addObject:button];
    }
    [self addViews];
}
- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    button.backgroundColor =[UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 10.0;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [[UIColor grayColor] CGColor];
    button.layer.masksToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (CGFloat)buttonWidthForButton:(UIButton *)button {
    CGFloat padding = 5.0;
    CGFloat labelWidth = [button.titleLabel sizeThatFits:CGSizeMake(self.frame.size.width, button.titleLabel.frame.size.height)].width;
    return (labelWidth + 2*padding);
}

- (void)addViews {
    CGFloat buttonMargin = 30.0;
    CGFloat buttonTotalMaxWidth = self.frame.size.width - 2*buttonMargin;
    CGFloat buttonTopMargin = 4.0;
    CGFloat buttonBottomMargin = 15.0;
    
    NSInteger lines = 1;
    CGFloat currentButtonTotalWidth = 0.0;
    
    for (NSInteger i = 0; i < _buttons.count; i++) {
        UIButton *currentButton = [_buttons objectAtIndex:i];
        CGRect currentButtonFrame = currentButton.frame;
        // 是否为新的一行
        if (currentButtonTotalWidth == 0.0) {
            currentButtonFrame.origin.x = buttonMargin;
            currentButtonFrame.origin.y = buttonTopMargin + (currentButtonFrame.size.height + self.buttonVerticalPadding) * (lines-1);
            currentButton.frame = currentButtonFrame;
            currentButtonTotalWidth += currentButtonFrame.size.width;
            
            if ((i+1) < _buttons.count) {
                UIButton *nextButton = [_buttons objectAtIndex:i + 1];
                CGRect nextButtonFrame = nextButton.frame;
                CGFloat ifPutNextButtonWidth = currentButtonTotalWidth + (nextButtonFrame.size.width + self.buttonHorizonalPadding);
                if (ifPutNextButtonWidth > buttonTotalMaxWidth) {
                    // 排在另一行
                    currentButtonTotalWidth = 0.0;
                    lines += 1;
                }
            }
        } else {
            currentButtonFrame.origin.x = buttonMargin + currentButtonTotalWidth + self.buttonHorizonalPadding;
            currentButtonFrame.origin.y = buttonTopMargin + (currentButtonFrame.size.height + self.buttonVerticalPadding) * (lines - 1);
            currentButton.frame = currentButtonFrame;
            currentButtonTotalWidth += (currentButtonFrame.size.width + self.buttonHorizonalPadding);
            
            if ((i+1) < _buttons.count) {
                UIButton *nextButton = [_buttons objectAtIndex:i + 1];
                CGRect nextButtonFrame = nextButton.frame;
                CGFloat ifPutNextButtonWidth = currentButtonTotalWidth + (nextButtonFrame.size.width + self.buttonHorizonalPadding);
                if (ifPutNextButtonWidth > buttonTotalMaxWidth) {
                    currentButtonTotalWidth = 0.0;
                    lines += 1;
                }
            }
        }
    }
    CGRect containFrame = self.frame;
    if (_buttons.count != 0) {
        UIButton *theButton = [_buttons objectAtIndex:0];
        containFrame.size.height = buttonTopMargin + buttonBottomMargin + lines * theButton.frame.size.height + (lines-1) * self.buttonVerticalPadding;
    }
    self.frame = containFrame;
    
    for (UIButton *button in _buttons) {
        [self addSubview:button];
    }
}

- (void)btnAction:(UIButton *)button {
    [self.delegate btnDelegateAction:button];
}

@end
