//
//  KyoUrlArgumentsFilter.h
//  KYONetWorking
//
//  Created by 张起哲 on 2017/12/6.
//  Copyright © 2017年 Dcamper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetworkConfig.h"
#import "YTKBaseRequest.h"

/// url 拼接 Arguments，用于全局参数，比如 AppVersion, ApiVersion 等
@interface OTUrlArgumentsFilter : NSObject<YTKUrlFilterProtocol>
+ (OTUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;
@end
