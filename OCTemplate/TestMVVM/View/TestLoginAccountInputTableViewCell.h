//
//  TestLoginAccountInputTableViewCell.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/27.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestLoginAccountInputTableViewCell : UITableViewCell<AOPViewProtocol>
/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

/**
 输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *inputTextFiled;
@end
