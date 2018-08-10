# OCTemplate

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)  ![](https://img.shields.io/badge/download-6.8MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

[EN](https://github.com/ReverseScale/OCTemplate) | [中文](https://github.com/ReverseScale/OCTemplate/blob/master/README_zh.md)

基于 Objective-C 实现的框架设计，YTKNetwork网络层 + AOP替代基类 + MVVM + ReactiveObjC + JLRoutes组件化 🤖

> 我理解的框架，就好比计算机的主板，房屋的建筑骨架，道路的基础设施配套，框架搭的好，能直接影响开发者的开发心情，更能让项目健壮性和扩展性大大增强。

![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/41712771.jpg)

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)  ![](https://img.shields.io/badge/download-6.8MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

----
### 🤖 要求

* iOS 8.0+
* Xcode 8.0+
* Objective-C

----
### 🎨 测试 UI 什么样子？

|1.展示页 |2.展示页 |3.展示页 |4.说明页 |
| ------------- | ------------- | ------------- | ------------- | 
| ![](https://user-gold-cdn.xitu.io/2018/2/7/1616f6935dd3886f?w=358&h=704&f=png&s=34082) | ![](https://user-gold-cdn.xitu.io/2018/4/25/162fc1ec1003f018?w=358&h=704&f=png&s=29004) | ![](https://user-gold-cdn.xitu.io/2018/4/25/162fc1f021208dde?w=358&h=704&f=png&s=42923) |  ![](https://user-gold-cdn.xitu.io/2018/4/25/162fc1fd987f8a76?w=358&h=704&f=png&s=38676) | 
| 登录视图 | 示例展示 | 跳转页面 | 介绍页面 | 

----
### 🎯 安装方法

#### 安装

在 *iOS*, 你需要在 Podfile 中添加.
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

  # 提示组件框架
  pod 'SVProgressHUD', '~> 2.2.2'
  # 网络请求框架
  pod 'YTKNetwork', '~> 2.0.3'
  # AOP面向切面
  pod 'Aspects', '~> 1.4.1'
  # 响应函数式框架
  pod 'ReactiveObjC', '~> 3.0.0'
  # 路由组件化解耦
  pod 'JLRoutes', '~> 2.0.5'
  # 提示组件框架
  pod 'SVProgressHUD', '~> 2.2.2'
  # 自动布局
  pod 'Masonry', '~> 1.0.2'
  # React 组件
  # 根据实际路径修改下面的`:path`
  pod 'React', :path => './react/node_modules/react-native', :subspecs => [
  'Core',
  'RCTText',
  'RCTNetwork',
  'RCTWebSocket', # 这个模块是用于调试功能的
  # 在这里继续添加你所需要的模块
  ]
  # 如果你的RN版本 >= 0.42.0，请加入下面这行
  #  pod "Yoga", :path => "./node_modules/react-native/ReactCommon/yoga"
  
```

----
### 🛠 框架介绍

#### 1.AOP 模式（Aspects-RunTime 代替基类）+ Category 方法交换

采用AOP思想，使用 Aspects 来完成替换 Controller ，View，ViewModel基类，和基类说拜拜

Casa反革命工程师 iOS应用架构谈 view层的组织和调用方案 博客中提到一个疑问
是否有必要让业务方统一派生ViewController

![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/12128058.jpg)

Casa大神回答是NO，原因如下
1. 使用派生比不使用派生更容易增加业务方的使用成本
2. 不使用派生手段一样也能达到统一设置的目的
对于第一点，从 集成成本 ，上手成本 ，架构维护成本等因素入手，大神博客中也已经很详细。

框架不需要通过继承即能够对ViewController进行统一配置。业务即使脱离环境，也能够跑完代码，ViewController一旦放入框架环境，不需要添加额外的或者只需添加少量代码，框架也能够起到相应的作用 对于本人来说 ，具备这点的吸引力，已经足够让我有尝试一番的心思了。

对于OC来说，方法拦截很容易就想到自带的黑魔法方法调配 Method Swizzling， 至于为ViewController做动态配置，自然非Category莫属了
Method Swizzling 业界已经有非常成熟的三方库 Aspects, 所以Demo代码采用 Aspects 做方法拦截。

```Objective-C
+ (void)load {
    [super load];
    [FKViewControllerIntercepter sharedInstance];
}
// .... 单例初始化代码

- (instancetype)init {
    self = [super init];
    if (self) {
        /* 方法拦截 */
        // 拦截 viewDidLoad 方法
        [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            [self _viewDidLoad:aspectInfo.instance];
        }  error:nil];
        
        // 拦截 viewWillAppear:
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self _viewWillAppear:animated controller:aspectInfo.instance];
        } error:NULL];
    }
    return self;
}
```

至于 Category 已经非常熟悉了

```Objective-C
@interface UIViewController (NonBase)

/**
 去Model&&表征化参数列表
 */
@property (nonatomic, strong) NSDictionary *params;

/**
 ViewModel 属性
 */
@property (nonatomic, strong) id <FKViewControllerProtocol> viewModel;

#pragma mark - 通用类

/**
 返回Controller的当前bounds
 
 @param hasNav 是否有导航栏
 @param hasTabBar 是否有tabbar
 @return 坐标
 */
- (CGRect)fk_visibleBoundsShowNav:(BOOL)hasNav showTabBar:(BOOL)hasTabBar;

/**
 隐藏键盘
 */
- (void)fk_hideKeyBoard;
@end
```
至此，我们已经实现了不继承基类来实现对ViewController的配置，项目中的 View ViewModel 去基类原理如出一辙。

#### 2.View层采用 MVVM 设计模式，使用 ReactiveObjC 进行数据绑定

*-MVC-*

作为老牌思想MVC，大家早已耳熟能详，MVC素有 Massive VC之称，随着业务增加，Controller将会越来越复杂，最终Controller会变成一个"神类", 即有网络请求等代码，又充斥着大量业务逻辑，所以为Controller减负，在某些情况下变得势在必行

*-MVVM-*

MVVM是基于胖Model的架构思路建立的，然后在胖Model中拆出两部分：Model和ViewModel (注：胖Model 是指包含了一些弱业务逻辑的Model)
胖Model实际上是为了减负 Controller 而存在的，而 MVVM 是为了拆分胖Model , 最终目的都是为了减负Controller。

我们知道，苹果MVC并没有专门为网络层代码分专门的层级，按照以往习惯，大家都写在了Controller 中，这也是Controller 变Massive得元凶之一，现在我们可以将网络请求等诸如此类的代码放到ViewModel中了 （文章后半部分将会描述ViewModel中的网络请求）

![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/75363007.jpg)

*-数据流向-*

正常的网络请求获取数据，然后更新View自然不必多说，那么如果View产生了数据要怎么把数据给到Model，由于View不直接持有ViewModel，所以我们需要有个桥梁 ReactiveCocoa, 通过 Signal 来和 ViewModel 通信，这个过程我们使用 通知 或者 Target-Action也可以实现相同的效果，只不过没有 ReactiveCocoa 如此方便罢了

```Objective-C
/*  View -> ViewModel 传递数据示例   */
#pragma mark - Bind ViewModel
- (void)bindViewModel:(id<FKViewModelProtocol>)viewModel withParams:(NSDictionary *)params {
    if ([viewModel isKindOfClass:[FKLoginViewModel class]]){
        
        FKLoginViewModel *_viewModel = (FKLoginViewModel *)viewModel;
        // 绑定账号 View -> ViewModel 传递数据 
        @weakify(self);
        RAC(_viewModel, userAccount) = [[self.inputTextFiled.rac_textSignal takeUntil:self.rac_prepareForReuseSignal] map:^id _Nullable(NSString * _Nullable account) {
            @strongify(self);
            // 限制账号长度
            if (account.length > 25) {
                self.inputTextFiled.text = [account substringToIndex:25];
            }
            return self.inputTextFiled.text;
        }];
    }
}
```

上面代码给出了 View -> ViewModel 绑定的一个例子 具体一些详情，可以直接看Demo
MVVM一些总结：
1. View <-> C <-> ViewModel <-> Model 实际上应该称之为MVCVM
2. Controller 将不再直接和 Model 进行绑定，而通过桥梁ViewModel
3. 最终 Controller 的作用变成一些UI的处理逻辑，和进行View和ViewModel的绑定
4. MVVM 和 MVC 兼容
5. 由于多了一层 ViewModel, 会需要写一些胶水代码，所以代码量会增加

#### 3.网络层使用 YTKNetwork 配合 ReactiveCocoa 封装网络请求，解决如何交付数据，交付什么样的数据（去Model化)等问题
YTKNetwork 是猿题库 iOS 研发团队基于 AFNetworking 封装的 iOS 网络库，其实现了一套 High Level 的 API，提供了更高层次的网络访问抽象。

笔者对 YTKNetwork 进行了一些封装，结合 ReactiveCocoa，并提供 reFormatter 接口对服务器响应数据重新处理，灵活交付给业务层。
接下来，本文会回答两个问题
1. 以什么方式将数据交付给业务层？
2. 交付什么样的数据 ?
对于第一个问题

*以什么方式将数据交付给业务层？*

![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/32067775.jpg)

虽然 iOS应用架构谈 网络层设计方案 中 Casa大神写到 尽量不要用block，应该使用代理
的确，Block难以追踪和定位错误，容易内存泄漏， YTKNetwork 也提供代理方式回调

```Objective-C
@protocol YTKRequestDelegate <NSObject>

@optional
///  Tell the delegate that the request has finished successfully.
///
///  @param request The corresponding request.
- (void)requestFinished:(__kindof YTKBaseRequest *)request;

///  Tell the delegate that the request has failed.
///
///  @param request The corresponding request.
- (void)requestFailed:(__kindof YTKBaseRequest *)request;

@end
```
前文有说过，MVVM 并不等于 ReactiveCocoa , 但是想要体验最纯正的 ReactiveCocoa 还是Block较为酸爽，Demo中笔者两者都给出了代码, 大家可以自行选择和斟酌哈
我们看一下 YTKNetwork 和 ReactiveCocoa 结合的代码

```Objective-C
- (RACSignal *)rac_requestSignal {
    [self stop];
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 请求起飞
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            // 成功回调
            [subscriber sendNext:[request responseJSONObject]];
            [subscriber sendCompleted];
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            // 错误回调
            [subscriber sendError:[request error]];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            // Signal销毁 停止请求
            [self stop];
        }];
    }] takeUntil:[self rac_willDeallocSignal]];
    
    //设置名称 便于调试
    if (DEBUG) {
        [signal setNameWithFormat:@"%@ -rac_xzwRequest",  RACDescription(self)];
    }
    
    return signal;
}
```

写了一个简单的 Category FKBaseRequest+Rac.h
ViewModel 中使用 RACCommand 封装调用：
```Objective-C
- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        @weakify(self);
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
      
            return [[[FKLoginRequest alloc] initWithUsr:self.userAccount pwd:self.password] rac_requestSignal];
        }];
    }
    return _loginCommand;
}
```
Block方式交付业务
```Objective-C
FKLoginRequest *loginRequest = [[FKLoginRequest alloc] initWithUsr:self.userAccount pwd:self.password];
return [[[loginRequest rac_requestSignal] doNext:^(id  _Nullable x) {
    
    // 解析数据
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isLogin"];
    
}] materialize];
```
Delegate方式交付业务
```Objective-C
FKLoginRequest *loginRequest = [[FKLoginRequest alloc] initWithUsr:self.userAccount pwd:self.password];
// 数据请求响应代理 通过代理回调
loginRequest.delegate = self;
return [loginRequest rac_requestSignal];

#pragma mark - YTKRequestDelegate
- (void)requestFinished:(__kindof YTKBaseRequest *)request {
    // 解析数据
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isLogin"];
}
```

*交付什么样的数据 ?*

现在诸如 JSONModel ，YYModel 之类的Json转Model的库也非常多，大多数Json对象，网络请求成功直接就被转成Model了
然而 iOS应用架构谈 网络层设计方案 中给出了两种有意思的交付思路
1. 使用 reformer 对数据进行清洗
2. 去特定对象表征 （去Model）

Casa文章中好处已经写得很详细了，通过不同的 reformer 来重塑和交付不同的业务数据，可以说是非常灵活了

*使用 reformer 对数据进行清洗*

在网络层封装 FKBaseRequest.h 中 给出了 FKBaseRequestFeformDelegate 接口来重塑数据
```Objective-C
@protocol FKBaseRequestFeformDelegate <NSObject>

/**
 自定义解析器解析响应参数

 @param request 当前请求
 @param jsonResponse 响应数据
 @return 自定reformat数据
 */
- (id)request:(FKBaseRequest *)request reformJSONResponse:(id)jsonResponse;

@end
然后在对应的 reformer 对数据进行重塑
#pragma mark - FKBaseRequestFeformDelegate
- (id)request:(FKBaseRequest *)request reformJSONResponse:(id)jsonResponse {
    if([request isKindOfClass:FKLoginRequest.class]){
        // 在这里对json数据进行重新格式化
    }
    return jsonResponse;
}
```
也可以直接在子类的 RequestManager 中覆盖父类方法达到一样的效果
```Objective-C
/* FKLoginRequest.m */

// 可以在这里对response 数据进行重新格式化， 也可以使用delegate 设置 reformattor
- (id)reformJSONResponse:(id)jsonResponse {
}
```

*去特定对象表征 （去Model）*

这思路可以说是业界的泥石流了
去Model也就是说，使用NSDictionary形式交付数据，对于网络层而言，只需要保持住原始数据即可，不需要主动转化成数据原型
但是会存在一些小问题
1. 去Model如何保持可读性？
2. 复杂和多样的数据结构如何解析？

Casa大神 提出了 使用EXTERN + Const 字符串形式，并建议字符串跟着reformer走，个人觉得很多时候API只需要一种解析格式，所以Demo跟着 APIManager 走，其他情况下常量字符串建议听从 Casa大神 的建议，
常量定义：

```Objective-C
/* FKBaseRequest.h */
// 登录token key
FOUNDATION_EXTERN NSString *FKLoginAccessTokenKey;

/* FKBaseRequest.m */
NSString *FKLoginAccessTokenKey = @"accessToken";
```

在 .h 和 .m 文件中要同时写太多代码，我们也可以使用局部常量的形式，只要在 .h 文件中定义即可

```Objective-C
// 也可以写成 局部常量形式
static const NSString *FKLoginAccessTokenKey2 = @"accessToken";
最终那么我们的reformer可能会变成这样子
- (id)request:(FKBaseRequest *)request reformJSONResponse:(id)jsonResponse {
    if([request isKindOfClass:FKLoginRequest.class]){
        // 在这里对json数据进行重新格式化
        
        return @{
                 FKLoginAccessTokenKey : jsonResponse[@"token"],
                 };
    }
    return jsonResponse;
}
```

复杂和多样的数据结构如何解析？
有时候，reformer 交付过来的数据，我们需要解析的可能是字符串类型，也可能是NSNumber类型，也有可能是数组
为此，笔者提供了一系列 Encode Decode方法，来降低解析的复杂度和安全性
```Objective-C
#pragma mark - Encode Decode 方法
// NSDictionary -> NSString
FK_EXTERN NSString* DecodeObjectFromDic(NSDictionary *dic, NSString *key);
// NSArray + index -> id
FK_EXTERN id        DecodeSafeObjectAtIndex(NSArray *arr, NSInteger index);
// NSDictionary -> NSString
FK_EXTERN NSString     * DecodeStringFromDic(NSDictionary *dic, NSString *key);
// NSDictionary -> NSString ？ NSString ： defaultStr
FK_EXTERN NSString* DecodeDefaultStrFromDic(NSDictionary *dic, NSString *key,NSString * defaultStr);
// NSDictionary -> NSNumber
FK_EXTERN NSNumber     * DecodeNumberFromDic(NSDictionary *dic, NSString *key);
// NSDictionary -> NSDictionary
FK_EXTERN NSDictionary *DecodeDicFromDic(NSDictionary *dic, NSString *key);
// NSDictionary -> NSArray
FK_EXTERN NSArray      *DecodeArrayFromDic(NSDictionary *dic, NSString *key);
FK_EXTERN NSArray      *DecodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic));

#pragma mark - Encode Decode 方法
// (nonull Key: nonull NSString) -> NSMutableDictionary
FK_EXTERN void EncodeUnEmptyStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key);
// nonull objec -> NSMutableArray
FK_EXTERN void EncodeUnEmptyObjctToArray(NSMutableArray *arr,id object);
// (nonull (Key ? key : defaultStr) : nonull Value) -> NSMutableDictionary
FK_EXTERN void EncodeDefaultStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key,NSString * defaultStr);
// (nonull Key: nonull object) -> NSMutableDictionary
FK_EXTERN void EncodeUnEmptyObjctToDic(NSMutableDictionary *dic,NSObject *object, NSString *key);
```
我们的reformer可以写成这样子
```Objective-C
#pragma mark - FKBaseRequestFeformDelegate
- (id)request:(FKBaseRequest *)request reformJSONResponse:(id)jsonResponse {
    if([request isKindOfClass:FKLoginRequest.class]){
        // 在这里对json数据进行重新格式化
        
        return @{
                 FKLoginAccessTokenKey : DecodeStringFromDic(jsonResponse, @"token")
                 };
    }
    return jsonResponse;
}
```
解析有可能是这样子
```Objective-C
NSString *token = DecodeStringFromDic(jsonResponse, FKLoginAccessTokenKey)
```
好了，至此我们解决了两个问题
1. 以什么方式将数据交付给业务层
答：delegate 最佳，block为次
2. 交付什么样的数据
答：纯字典，去Model

#### 4.采用 JLRoutes 路由 对应用进行组件化解耦
iOS应用架构谈 组件化方案 一文中 Casa 针对 蘑菇街组件化 提出了质疑，质疑点主要在这几方面
1. App启动时组件需要注册URL
2. URL调用组件方式不太好传递类似 UIImage 等非常规对象
3. URL需要添加额外参数可读性差，所以没必要使用URL

对于 App启动时组件需要注册URL 顾虑主要在于，注册的URL需要在应用生存周期内常驻内存，如果是注册Class还好些，如果注册的是实例，消耗的内存就非常可观了

```Objective-C
#pragma mark - 路由表
NSString *const FKNavPushRoute = @"/com_madao_navPush/:viewController";
NSString *const FKNavPresentRoute = @"/com_madao_navPresent/:viewController";
NSString *const FKNavStoryBoardPushRoute = @"/com_madao_navStoryboardPush/:viewController";
NSString *const FKComponentsCallBackRoute = @"/com_madao_callBack/*";
```
而且JLRoutes 还支持 * 来进行通配，路由表如何编写大家可以自由发挥
对应的路由事件 handler

```Objective-C
// push
// 路由 /com_madao_navPush/:viewController
[[JLRoutes globalRoutes] addRoute:FKNavPushRoute handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _handlerSceneWithPresent:NO parameters:parameters];
        
    });
    return YES;
}];

// present
// 路由 /com_madao_navPresent/:viewController
[[JLRoutes globalRoutes] addRoute:FKNavPresentRoute handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _handlerSceneWithPresent:YES parameters:parameters];
        
    });
    return YES;
}];

#pragma mark - Private
/// 处理跳转事件
- (void)_handlerSceneWithPresent:(BOOL)isPresent parameters:(NSDictionary *)parameters {
    // 当前控制器
    NSString *controllerName = [parameters objectForKey:FKControllerNameRouteParam];
    UIViewController *currentVC = [self _currentViewController];
    UIViewController *toVC = [[NSClassFromString(controllerName) alloc] init];
    toVC.params = parameters;
    if (currentVC && currentVC.navigationController) {
        if (isPresent) {
            [currentVC.navigationController presentViewController:toVC animated:YES completion:nil];
        }else
        {
            [currentVC.navigationController pushViewController:toVC animated:YES];
        }
    }
}
```

通过URL中传入的组件名动态注册，处理相应跳转事件，并不需要每个组件一一注册
使用URL路由，必然URL会散落到代码各个地方

```Objective-C
NSString *key = @"key";
NSString *value = @"value";
NSString *url = [NSString stringWithFormat:@"/com_madao_navPush/%@?%@=%@", NSStringFromClass(ViewController.class), key, value];
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
```
诸如此类丑陋的代码，散落在各个地方的话简直会让人头皮发麻, 所以笔者在 JLRoutes+GenerateURL.h 写了一些 Helper方法
```Objective-C
/**
 避免 URL 散落各处， 集中生成URL
 
 @param pattern 匹配模式
 @param parameters 附带参数
 @return URL字符串
 */
+ (NSString *)fk_generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters;

/**
 避免 URL 散落各处， 集中生成URL
 额外参数将被 ?key=value&key2=value2 样式给出
 
 @param pattern 匹配模式
 @param parameters 附加参数
 @param extraParameters 额外参数
 @return URL字符串
 */
+ (NSString *)fk_generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters extraParameters:(NSDictionary *)extraParameters;

/**
 解析NSURL对象中的请求参数
http://madao?param1=value1¶m2=value2 解析成 @{param1:value1, param2:value2}
 @param URL NSURL对象
 @return URL字符串
 */
+ (NSDictionary *)fk_parseParamsWithURL:(NSURL *)URL;

/**
 将参数对象进行url编码
 将@{param1:value1, param2:value2} 转换成 ?param1=value1&param2=value2
 @param dic 参数对象
 @return URL字符串
 */
+ (NSString *)fk_mapDictionaryToURLQueryString:(NSDictionary *)dic;
```
宏定义Helper
```Objective-C
#undef JLRGenRoute
#define JLRGenRoute(Schema, path) \
([NSString stringWithFormat: @"%@:/%@", \
Schema, \
path])

#undef JLRGenRouteURL
#define JLRGenRouteURL(Schema, path) \
([NSURL URLWithString: \
JLRGenRoute(Schema, path)])
```
最终我们的调用可以变成
```Objective-C
NSString *router = [JLRoutes fk_generateURLWithPattern:FKNavPushRoute parameters:@[NSStringFromClass(ViewController.class)] extraParameters:nil];
[[UIApplication sharedApplication] openURL:JLRGenRouteURL(FKDefaultRouteSchema, router)];
```

----
### 📝 原文地址

简书博客：http://www.jianshu.com/p/921dd65e79cb  
Casa Taloyum：https://casatwy.com/modulization_in_action.html  
整理制作

----
### ⚖ 协议

```
MIT License

Copyright (c) 2017 ReverseScale

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

----
### 😬 联系

* 微信 : WhatsXie
* 邮件 : ReverseScale@iCloud.com
* 博客 : https://reversescale.github.io
