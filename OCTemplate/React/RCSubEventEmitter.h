//
//  RCSubEventEmitter.h
//  OCTemplate
//
//  Created by WhatsXie on 2018/5/3.
//  Copyright © 2018年 R.S. All rights reserved.
//

#import <React/RCTEventEmitter.h>

@interface RCSubEventEmitter : RCTEventEmitter<RCTBridgeModule>
- (void)Callback:(NSString*)code result:(NSString*) result;
@end
