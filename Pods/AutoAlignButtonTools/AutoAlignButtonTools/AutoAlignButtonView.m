//
//  AutoAlignButtonView.m
//  AutoAlignButton
//
//  Created by StevenXie on 2017/4/26.
//  Copyright © 2017年 StevenXie. All rights reserved.
//

#import "AutoAlignButtonView.h"

@implementation AutoAlignButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dataTitleArray = [NSArray array];
        self.dataImagesArray = [NSArray array];
        self.buttons = [NSMutableArray array];
        self.isScratchableLatex = YES;
        self.isCornerRadius = NO;
        self.buttonVerticalPadding = 15.0;
        self.buttonHorizonalPadding = 14.0;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < self.dataTitleArray.count; i++) {
        if (self.dataTitleArray.count == 0 || self.dataImagesArray.count == 0) {
            return;
        }
        RSCardButton *button = [self createButtonWithTitle:self.dataTitleArray[i] image:self.dataImagesArray[i]];
        CGRect buttonFrame = button.frame;
        CGFloat buttonWidth = [self buttonWidthForButton:button];
        buttonFrame.size.width = buttonWidth;
        button.frame = buttonFrame;
        [self.buttons addObject:button];
    }
    [self addViews];
}
- (RSCardButton *)createButtonWithTitle:(NSString *)title image:(NSString *)imageName {
    RSCardButton *button = [[RSCardButton alloc] initWithFrame:CGRectMake(0, 0, 0, 88)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.isCornerRadius) {
        button.layer.cornerRadius = 10.0;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [[UIColor grayColor] CGColor];
        button.layer.masksToBounds = YES;
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return button;
}

- (CGFloat)buttonWidthForButton:(RSCardButton *)button {
    if (self.isScratchableLatex) {
        CGFloat labelWidth = (self.frame.size.width - 60) / self.countHorizonal;
        self.buttonHorizonalPadding = 0.0;
        self.buttonVerticalPadding = 0.0;
        return labelWidth;
    } else {
        CGFloat padding = 5.0f;
        CGFloat labelWidth = [button.titleLabel sizeThatFits:CGSizeMake(self.frame.size.width, button.titleLabel.frame.size.height)].width;
        return (labelWidth + 2*padding);
    }
}

- (void)addViews {
    CGFloat buttonMargin = 30.0;
    CGFloat buttonTotalMaxWidth = self.frame.size.width - 2*buttonMargin;
    CGFloat buttonTopMargin = 4.0;
    CGFloat buttonBottomMargin = 15.0;
    
    NSInteger lines = 1;
    CGFloat currentButtonTotalWidth = 0.0;
    
    for (NSInteger i = 0; i < _buttons.count; i++) {
        RSCardButton *currentButton = [_buttons objectAtIndex:i];
        CGRect currentButtonFrame = currentButton.frame;
        // 是否为新的一行
        if (currentButtonTotalWidth == 0.0) {
            currentButtonFrame.origin.x = buttonMargin;
            currentButtonFrame.origin.y = buttonTopMargin + (currentButtonFrame.size.height + self.buttonVerticalPadding) * (lines-1);
            currentButton.frame = currentButtonFrame;
            currentButtonTotalWidth += currentButtonFrame.size.width;
            
            if ((i+1) < _buttons.count) {
                RSCardButton *nextButton = [_buttons objectAtIndex:i + 1];
                CGRect nextButtonFrame = nextButton.frame;
                CGFloat ifPutNextButtonWidth = currentButtonTotalWidth + (nextButtonFrame.size.width + self.buttonHorizonalPadding);
                if (ifPutNextButtonWidth > buttonTotalMaxWidth) {
                    // 排在另一行
                    currentButtonTotalWidth = 0.0;
                    lines += 1;
                }
            }
        }else{
            currentButtonFrame.origin.x = buttonMargin + currentButtonTotalWidth + self.buttonHorizonalPadding;
            currentButtonFrame.origin.y = buttonTopMargin + (currentButtonFrame.size.height + self.buttonVerticalPadding) * (lines - 1);
            currentButton.frame = currentButtonFrame;
            currentButtonTotalWidth += (currentButtonFrame.size.width + self.buttonHorizonalPadding);
            
            if ((i+1) < _buttons.count) {
                RSCardButton *nextButton = [_buttons objectAtIndex:i + 1];
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
        RSCardButton *theButton = [_buttons objectAtIndex:0];
        containFrame.size.height = buttonTopMargin + buttonBottomMargin + lines * theButton.frame.size.height + (lines-1) * self.buttonVerticalPadding;
    }
    self.frame = containFrame;
    
    for (RSCardButton *button in _buttons) {
        [self addSubview:button];
    }
}

- (void)btnAction:(RSCardButton *)button {
    [self.delegate btnDelegateAction:button];
}


@end
