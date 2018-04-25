//
//  PushViewController.m
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "PushViewController.h"

@interface PushViewController ()
@property (weak, nonatomic) IBOutlet UILabel *paramsLabel;

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"推出页";
    
    self.paramsLabel.text = [NSString stringWithFormat:@"参数 key:%@", self.params[@"key"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
