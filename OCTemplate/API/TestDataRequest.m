//
//  DcampRequestApi.m
//  KYONetWorking
//
//  Created by 张起哲 on 2017/12/6.
//  Copyright © 2017年 Dcamper. All rights reserved.
//

#import "TestDataRequest.h"

@implementation TestDataRequest {
    NSInteger _page;
    NSInteger _pageSize;
}

- (id)initWithPage:(NSInteger)page pageSize:(NSInteger)pageSize{
    self = [super init];
    if (self) {
        _page = page;
        _pageSize = pageSize;
    }
    return self;
}

- (void)resetPage{
    _page = 1;
}

- (void)loadNextPage{
    _page++;
}

- (NSString *)requestUrl{
    return @"/api/camp/list";
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

//请求参数
- (id)requestArgument{
    return @{
             @"page": @(_page),
             @"pageSize": @(_pageSize)
             };
}

//验证服务器返回内容
//- (id)jsonValidator {
//    return @{
//             @"nick": [NSString class],
//             @"level": [NSNumber class]
//             };
//}

//按时间缓存内容
//该缓存逻辑对上层是透明的，所以上层可以不用考虑缓存逻辑，每次调用 xxxApi 的 start 方法即可。xxxApi 只有在缓存过期时，才会真正地发送网络请求。
- (NSInteger)cacheTimeInSeconds {
    // 3 分钟 = 180 秒
    return 60 * 3;
}

//使用 CDN 地址
- (BOOL)useCDN {
    return NO;
}

/*
//上传文件：我们可以通过覆盖 constructingBodyBlock 方法，来方便地上传图片等附件
 */
//- (AFConstructingBlock)constructingBodyBlock {
//    return ^(id<AFMultipartFormData> formData) {
//        NSData *data = UIImageJPEGRepresentation(_image, 0.9);//UIImagePNGRepresentation
//        NSString *name = @"image";
//        NSString *formKey = @"image";
//        NSString *type = @"image/jpeg";
//        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
//    };
//}

/*
//要启动断点续传功能，只需要覆盖 resumableDownloadPath 方法，指定断点续传时文件的存储路径即可，文件会被自动保存到此路径。
//- (NSString *)resumableDownloadPath {
//    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
//    NSString *filePath = [cachePath stringByAppendingPathComponent:_imageId];
//    return filePath;
//}
 */

/*
// 构建自定义的 UrlRequest，
// 如果构建自定义的 request，会忽略其他的一切自定义 request 的方法，例如 requestUrl, requestArgument, requestMethod, requestSerializerType,requestHeaderFieldValueDictionary 等等。一个上传 gzippingData 的示例如下
 */
//- (NSURLRequest *)buildCustomUrlRequest {
//    NSData *rawData = [[_events jsonString] dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *gzippingData = [NSData gtm_dataByGzippingData:rawData];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]];
//    [request setHTTPMethod:@"POST"];
//    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
//    [request setHTTPBody:gzippingData];
//    return request;
//}

@end
