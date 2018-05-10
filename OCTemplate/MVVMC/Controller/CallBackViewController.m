//
//  CallBackViewController.m
//  OCTemplate
//
//  Created by WhatsXie on 2018/5/10.
//  Copyright © 2018年 R.S. All rights reserved.
//

#import "CallBackViewController.h"

@interface CallBackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@end

@implementation CallBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.codeLabel.text = [NSString stringWithFormat:@"授权码 参数 code:%@", self.params[@"code"]];
    // 可以用该APP的服务端
    // TODO: OAuth /token: client_id, client_secret, code
    
    // 客户端拿着accessToken就能一直访问资源了，直到过期。

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
