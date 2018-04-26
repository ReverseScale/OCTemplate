//
//  DcampRequestApi.h
//  KYONetWorking
//
//  Created by 张起哲 on 2017/12/6.
//  Copyright © 2017年 Dcamper. All rights reserved.
//

#import "OTBaseRequest.h"

@interface TestDataRequest : OTBaseRequest
- (id)initWithPage:(NSInteger )page pageSize:(NSInteger)pageSize;
- (void)resetPage;
- (void)loadNextPage;
@end
