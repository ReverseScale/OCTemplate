//
//  FKBaseRequest+Rac.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import "OTLoginRequest.h"

@interface OTLoginRequest (Rac)


- (RACSignal *)rac_requestSignal;

@end
