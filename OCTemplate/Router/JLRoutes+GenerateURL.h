//
//  JLRoutes+GenerateURL.h
//  OCTemplate
//
//  Created by WhatsXie on 2017/12/28.
//  Copyright © 2017年 R.S. All rights reserved.
//

#import <JLRoutes/JLRoutes.h>

#undef JLRGenRoute
#define JLRGenRoute(Schema, path) \
([NSString stringWithFormat: @"%@:/%@", \
Schema, \
path])

#undef JLRGenRouteURL
#define JLRGenRouteURL(Schema, path) \
([NSURL URLWithString: \
[JLRGenRoute(Schema, path) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]])


@interface JLRoutes (GenerateURL)

/**
 避免 URL 散落各处， 集中生成URL
 
 @param pattern 匹配模式
 @param parameters 附带参数
 @return URL字符串
 */
+ (NSString *)rs_generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters;

/**
 避免 URL 散落各处， 集中生成URL
 额外参数将被 ?key=value&key2=value2 样式给出
 
 @param pattern 匹配模式
 @param parameters 附加参数
 @param extraParameters 额外参数
 @return URL字符串
 */
+ (NSString *)rs_generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters extraParameters:(NSDictionary *)extraParameters;

/**
 解析NSURL对象中的请求参数
 http://madao?param1=value1&param2=value2 解析成 @{param1:value1, param2:value2}
 @param URL NSURL对象
 @return URL字符串
 */
+ (NSDictionary *)rs_parseParamsWithURL:(NSURL *)URL;

/**
 将参数对象进行url编码
 将@{param1:value1, param2:value2} 转换成 ?param1=value1&param2=value2
 @param dic 参数对象
 @return URL字符串
 */
+ (NSString *)rs_mapDictionaryToURLQueryString:(NSDictionary *)dic;


@end
