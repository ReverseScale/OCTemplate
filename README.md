# OCTemplate

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)  ![](https://img.shields.io/badge/download-6.8MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

[EN](https://github.com/ReverseScale/OCTemplate) | [中文](https://github.com/ReverseScale/OCTemplate/blob/master/README_zh.md)

Framework Design Based on Objective-C Implementation, YTKNetwork Network + AOP Substitution Base + MVVM + ReactiveObjC + JLRoutes Components 🤖

> I understand the framework, like the computer's motherboard, building the framework of the building, the infrastructure of the road infrastructure, the framework take a good, can directly affect the developer's development mood, but also make the project robustness and scalability greatly enhanced.

![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/41712771.jpg)

----
### 🤖 Requirements

* iOS 8.0+
* Xcode 8.0+
* Objective-C

----
### 🎨 Why test the UI?

|1. Presentation page | 2. Presentation page | 3. Presentation page | 4. Description page |
| ------------- | ------------- | ------------- | ------------- | 
| ![](https://user-gold-cdn.xitu.io/2018/2/7/1616f6935dd3886f?w=358&h=704&f=png&s=34082) | ![](https://user-gold-cdn.xitu.io/2018/4/25/162fc1ec1003f018?w=358&h=704&f=png&s=29004) | ![](https://user-gold-cdn.xitu.io/2018/4/25/162fc1f021208dde?w=358&h=704&f=png&s=42923) |  ![](https://user-gold-cdn.xitu.io/2018/4/25/162fc1fd987f8a76?w=358&h=704&f=png&s=38676) | 
| Login View | Sample Show | Jump Page | Introduction Page |

----
### 🎯 Installation

#### Install

In * iOS *, you need to add in Podfile.
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

  # Prompt component framework
  pod 'SVProgressHUD', '~> 2.2.2'
  # Network request framework
  pod 'YTKNetwork', '~> 2.0.3'
  # AOP oriented aspect
  pod 'Aspects', '~> 1.4.1'
  # Response function framework
  pod 'ReactiveObjC', '~> 3.0.0'
  # Decoupling of routing components
  pod 'JLRoutes', '~> 2.0.5'
  # Prompt component framework
  pod 'SVProgressHUD', '~> 2.2.2'
  # Automatic layout
  pod 'Masonry', '~> 1.0.2'
  # React component
  # Modify the following `:path' based on the actual path
  pod 'React', :path => './react/node_modules/react-native', :subspecs => [
  'Core',
  'RCTText',
  'RCTNetwork',
  'RCTWebSocket', # This module is for debugging
  # Continue to add the modules you need here
  ]
  # If your RN version >= 0.42.0, please add this line
  #  pod "Yoga", :path => "./node_modules/react-native/ReactCommon/yoga"
```

----
### 🛠 Framework introduction

#### 1.AOP mode (Aspects-RunTime instead of base class) + Category method exchange

Adopt AOP ideas, use Aspects to complete the replacement Controller, View, ViewModel base class, and base class say goodbye

Casa Counterrevolutionary Engineer iOS Application Architecture Talking about layering and calling scenarios in the blog
Is it necessary to have the business side derive ViewController

![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/12128058.jpg)

Casa God reply is NO, the reason is as follows
1. Using Derivatives Instead of using Derivatives it is easier to increase the cost of using the business side
2. The purpose of uniform setting can also be achieved without using derivative means
For the first point, from the integration costs, start-up costs, infrastructure maintenance costs and other factors start, the Great God blog has also been very detailed.

The framework does not need to be able to uniformly configure the ViewController through inheritance. Business even out of the environment, can run the code, ViewController once into the framework of the environment, do not need to add extra or just add a small amount of code, the framework can also play a corresponding role For me, with this attractive, Enough for me to try something.

For OC, method interception is easy to think of the method that comes with the black magic method Method Swizzling, as for the dynamic configuration of the ViewController, natural non-Category must be
Method Swizzling The industry already has a very sophisticated three-way library, Aspects, so the Demo code uses Aspects to do method interception.

```Objective-C
+ (void)load {
    [super load];
    [FKViewControllerIntercepter sharedInstance];
}
// .... Singleton initialization code

- (instancetype)init {
    self = [super init];
    if (self) {
        / * Method to intercept * /
        // Intercept the viewDidLoad method
        [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            [self _viewDidLoad:aspectInfo.instance];
        }  error:nil];
        
        // Intercept viewWillAppear:
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self _viewWillAppear:animated controller:aspectInfo.instance];
        } error:NULL];
    }
    return self;
}
```

As for Category, it is already very familiar with

```Objective-C
@interface UIViewController (NonBase)

/**
 Go to Model && characterization parameter list
 */
@property (nonatomic, strong) NSDictionary *params;

/**
 ViewModel property
 */
@property (nonatomic, strong) id <FKViewControllerProtocol> viewModel;

#pragma mark - Common class

/**
  Returns the current bounds of the Controller
 
  @param hasNav whether there is navigation bar
  @param hasTabBar whether there is a tabbar
  @return coordinates
 */
- (CGRect)fk_visibleBoundsShowNav:(BOOL)hasNav showTabBar:(BOOL)hasTabBar;

/**
 Hide the keyboard
 */
- (void)fk_hideKeyBoard;
@end
```
So far, we have achieved the configuration of ViewController does not inherit the base class, the project View ViewModel to base class principle is exactly the same.

#### 2.View layer MVVM design pattern, the use of ReactiveObjC data binding

* -MVC- *

MVC as a veteran thinking, we have long been familiar, MVC is known as Massive VC, as the business increases, the Controller will be more complex, eventually Controller will become a "god class", that is, there are requests for network code, and flooded With a lot of business logic, so for the Controller to reduce the burden, in some cases become imperative.

* -MVVM- *

MVVM is based on the idea of the fat Model architecture, and then split in the fat Model in two parts: Model and ViewModel (Note: Fat Model refers to the model contains some weak business logic)
Fat Model is actually to reduce the burden of Controller exists, and the MVVM is to split the fat Model, the ultimate goal is to reduce the burden Controller.

We know that Apple MVC is not dedicated to the network layer code sub-level, in accordance with past habits, we are all written in the Controller, which is one of the culprit Controller Variable Massive, and now we can put such requests for network requests and so on Into ViewModel (the second half of the article will describe network requests in ViewModel).

![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/75363007.jpg)

* - Data Flow - *

The normal network request to obtain data, and then update the View natural need not say, then if the View generates data to how to give data to the Model, because the View does not directly hold the ViewModel, so we need to have a bridge ReactiveCocoa, through Signal and ViewModel Communication, this process we use notification or Target-Action can achieve the same effect, but no ReactiveCocoa so convenient.

```Objective-C
/*  View -> ViewModel to pass data example   */
#pragma mark - Bind ViewModel
- (void)bindViewModel:(id<FKViewModelProtocol>)viewModel withParams:(NSDictionary *)params {
    if ([viewModel isKindOfClass:[FKLoginViewModel class]]){
        
        FKLoginViewModel *_viewModel = (FKLoginViewModel *)viewModel;
        // Bind account View -> ViewModel to pass data
        @weakify(self);
        RAC(_viewModel, userAccount) = [[self.inputTextFiled.rac_textSignal takeUntil:self.rac_prepareForReuseSignal] map:^id _Nullable(NSString * _Nullable account) {
            @strongify(self);
            // Limit account length
            if (account.length > 25) {
                self.inputTextFiled.text = [account substringToIndex:25];
            }
            return self.inputTextFiled.text;
        }];
    }
}
```

The code given above View -> ViewModel binding an example of some specific details, you can see Demo
Some conclusions of MVVM:
1. View <-> C <-> ViewModel <-> The Model should actually be called MVCVM
2. Controller will no longer be directly bound to the Model ViewModel through the bridge
3. The role of the final controller into some UI processing logic, and View and ViewModel binding
4. MVVM and MVC Compatible
5. Due to a layer of ViewModel, will need to write some glue code, so the amount of code will increase

#### 3. Network layer YTKNetwork with ReactiveCocoa package network request, how to solve the delivery of data, what kind of data delivery (to Model) and other issues
YTKNetwork is ape problem library iOS R & D team based on AFNetworking package iOS network library, which implements a set of High Level API, provides a higher level of network access abstraction.

The author of YTKNetwork some packages, combined with ReactiveCocoa, and provide the reFormatter interface to the server response data reprocessing, flexible delivery to the business layer.
Next, this article will answer two questions
1. In what ways will data be delivered to the business layer?
2. What kind of data is delivered?
For the first question

* In what way will data be delivered to the business layer? *

![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/32067775.jpg)

Although the iOS application architecture talks about the design of the network layer, Casa da Shen wrote that try not to use block, you should use proxy
Indeed, Block is difficult to track and locate errors, easy memory leaks, YTKNetwork also provides proxy mode callback.

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
As mentioned earlier, MVVM is not equal to ReactiveCocoa, but you want to experience the most pure ReactiveCocoa or Block more sour, Demo I have given both the code, we can choose and consider Ha
Let's take a look at the combined code of YTKNetwork and ReactiveCocoa.

```Objective-C
- (RACSignal *)rac_requestSignal {
    [self stop];
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // Request to take off
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            // Successful callback
            [subscriber sendNext:[request responseJSONObject]];
            [subscriber sendCompleted];
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            // Error callback
            [subscriber sendError:[request error]];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            // Signal destruction stop request
            [self stop];
        }];
    }] takeUntil:[self rac_willDeallocSignal]];
    
    // Setting name Easy to debug
    if (DEBUG) {
        [signal setNameWithFormat:@"%@ -rac_xzwRequest",  RACDescription(self)];
    }
    
    return signal;
}
```

Wrote a simple Category FKBaseRequest + Rac.h
Use RACCommand Encapsulation Call in ViewModel:

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

Block way to deliver business

```Objective-C
FKLoginRequest *loginRequest = [[FKLoginRequest alloc] initWithUsr:self.userAccount pwd:self.password];
return [[[loginRequest rac_requestSignal] doNext:^(id  _Nullable x) {
    
    // Analytical data
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isLogin"];
    
}] materialize];
```

Delegate way to deliver business

```Objective-C
FKLoginRequest *loginRequest = [[FKLoginRequest alloc] initWithUsr:self.userAccount pwd:self.password];
// The data request response proxy calls back through the proxy
loginRequest.delegate = self;
return [loginRequest rac_requestSignal];

#pragma mark - YTKRequestDelegate
- (void)requestFinished:(__kindof YTKBaseRequest *)request {
    // Analytical data
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isLogin"];
}
```

* What kind of data is delivered? *

Now there are many Json-to-Model libraries such as JSONModel and YYModel. Most Json objects have been converted to Model directly after successful web requests.
However, the iOS application architecture gives two interesting delivery ideas in the network layer design scenario.
1. Use the reformer to clean the data
2. To the specific object characterization (to Model)

The benefits of the Casa article have been written in great detail. It is very flexible to reshape and deliver different business data through different reformers

* Use the reformer to clean the data *

In the network layer package FKBaseRequest.h FKBaseRequestFeformDelegate interface is given to reshape the data.

```Objective-C
@protocol FKBaseRequestFeformDelegate <NSObject>

/**
  Custom parser parses the response parameters

  @param request current request
  @param jsonResponse response data
  @return custom reformat data
 */
- (id)request:(FKBaseRequest *)request reformJSONResponse:(id)jsonResponse;

@end
// Then the corresponding reformer data reshaping
#pragma mark - FKBaseRequestFeformDelegate
- (id)request:(FKBaseRequest *)request reformJSONResponse:(id)jsonResponse {
    if([request isKindOfClass:FKLoginRequest.class]){
        // JSON data is reformatted here
    }
    return jsonResponse;
}
```

You can also override the parent method directly in the RequestManager subclasses to achieve the same effect

```Objective-C
/* FKLoginRequest.m */

// You can reformat the response data here, or use the delegate to set reformattor
- (id)reformJSONResponse:(id)jsonResponse {
}
```

* Go to the specific object characterization (to Model) *

This idea can be said that the industry's debris flow
To Model That is to say, the use of NSDictionary form of delivery of data, the network layer, only need to keep the original data can be, do not need to be actively converted into a data prototype.
But there will be some minor problems:
1. To Model how to maintain readability?
2. How to interpret complex and diverse data structures?

Casa God proposed the use of EXTERN + Const string form, and suggested that the string follows the reformer, personally feel that many times the API only needs a parsing format, so Demo follows the APIManager. In other cases, the constant string suggests to listen to the advice of Casa Great God. 
Constant definition:

```Objective-C
/* FKBaseRequest.h */
// Login token key
FOUNDATION_EXTERN NSString *FKLoginAccessTokenKey;

/* FKBaseRequest.m */
NSString *FKLoginAccessTokenKey = @"accessToken";
```

To write too much code at the same time in the .h and .m files, we can also use local constants as long as they are defined in the .h file.

```Objective-C
// Can also be written as a partial constant form
static const NSString *FKLoginAccessTokenKey2 = @"accessToken";
// In the end, then our reformer may become like this
- (id)request:(FKBaseRequest *)request reformJSONResponse:(id)jsonResponse {
    if([request isKindOfClass:FKLoginRequest.class]){
        // reformat json data here
        return @{
                 FKLoginAccessTokenKey : jsonResponse[@"token"],
                 };
    }
    return jsonResponse;
}
```

How to interpret complex and diverse data structures?
Sometimes, reformer data delivered, we need to resolve the string type, it may be NSNumber type, it may be an array
To this end, I provide a series of Encode Decode method to reduce the complexity and security analysis.

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

#pragma mark - Encode Decode method
// (nonull Key: nonull NSString) -> NSMutableDictionary
FK_EXTERN void EncodeUnEmptyStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key);
// nonull objec -> NSMutableArray
FK_EXTERN void EncodeUnEmptyObjctToArray(NSMutableArray *arr,id object);
// (nonull (Key ? key : defaultStr) : nonull Value) -> NSMutableDictionary
FK_EXTERN void EncodeDefaultStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key,NSString * defaultStr);
// (nonull Key: nonull object) -> NSMutableDictionary
FK_EXTERN void EncodeUnEmptyObjctToDic(NSMutableDictionary *dic,NSObject *object, NSString *key);
```

Our reformer can be written like this

```Objective-C
#pragma mark - FKBaseRequestFeformDelegate
- (id)request:(FKBaseRequest *)request reformJSONResponse:(id)jsonResponse {
    if([request isKindOfClass:FKLoginRequest.class]){
        // JSON data is reformatted here
        
        return @{
                 FKLoginAccessTokenKey : DecodeStringFromDic(jsonResponse, @"token")
                 };
    }
    return jsonResponse;
}
```

Analysis may be like this

```Objective-C
NSString *token = DecodeStringFromDic(jsonResponse, FKLoginAccessTokenKey)
```
Well, so far we have solved two problems
1. In what ways will data be delivered to the business layer
A: delegate the best block for the times
2. What kind of data is delivered
A: pure dictionary, to Model

#### 4. Using JLRoutes Routing Component Decoupling of Applications
IOS application architecture talk about the component of the program in which a copy of the Casa for Mackay Street questioned the main points in these areas:
1. App start component registration URL
2. URL calling component is not very good to pass non-conventional objects such as UIImage
3. The URL needs to add extra parameters and has poor readability, so it is not necessary to use the URL

For App startup components need to register URL concerns mainly lies in the registered URL needs to be resident memory in the application life cycle, if registered Class is better, if registered is an instance, the memory consumption is very impressive.

```Objective-C
#pragma mark - Routing table
NSString *const FKNavPushRoute = @"/com_madao_navPush/:viewController";
NSString *const FKNavPresentRoute = @"/com_madao_navPresent/:viewController";
NSString *const FKNavStoryBoardPushRoute = @"/com_madao_navStoryboardPush/:viewController";
NSString *const FKComponentsCallBackRoute = @"/com_madao_callBack/*";
```
And JLRoutes also supports * for wildcarding, how the routing table is written for everyone to play freely.
The corresponding routing event handler.

```Objective-C
// push
// routing /com_madao_navPush/:viewController
[[JLRoutes globalRoutes] addRoute:FKNavPushRoute handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _handlerSceneWithPresent:NO parameters:parameters];
        
    });
    return YES;
}];

// present
// routing /com_madao_navPresent/:viewController
[[JLRoutes globalRoutes] addRoute:FKNavPresentRoute handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _handlerSceneWithPresent:YES parameters:parameters];
        
    });
    return YES;
}];

#pragma mark - Private
/// Handle jump events
- (void)_handlerSceneWithPresent:(BOOL)isPresent parameters:(NSDictionary *)parameters {
    // Current controller
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

Dynamic registration through the component name passed in the URL, handle the corresponding jump event, do not need to register each component one by one.
Using URL routing, the inevitable URL will be scattered in all parts of the code.

```Objective-C
NSString *key = @"key";
NSString *value = @"value";
NSString *url = [NSString stringWithFormat:@"/com_madao_navPush/%@?%@=%@", NSStringFromClass(ViewController.class), key, value];
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
```

Such ugly code, scattered in various places will simply scalp numb, so I wrote some helper methods in JLRoutes + GenerateURL.h.

```Objective-C
/**
  Avoid URLs scattered around, generate URL
 
  @param pattern matching mode
  @param parameters with parameters
  @return URL string
 */
+ (NSString *)fk_generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters;

/**
  Avoid URLs scattered around, generate URL
  Additional parameters will be given by the key = value & key2 = value2 style
 
  @param pattern matching mode
  @param parameters Additional parameters
  @param extraParameters extra parameters
  @return URL string
 */
+ (NSString *)fk_generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters extraParameters:(NSDictionary *)extraParameters;

/**
  Parse NSURL object request parameters
http: // madao? param1 = value1¶ m2 = value2 resolve to @ {param1: value1, param2: value2}
  @param URL NSURL object
  @return URL string
 */
+ (NSDictionary *)fk_parseParamsWithURL:(NSURL *)URL;

/**
  Url parameter object encoding
  Convert @{param1:value1, param2:value2} to ?param1=value1&param2=value2
  @param dic parameter object
  @return URL string
 */
+ (NSString *)fk_mapDictionaryToURLQueryString:(NSDictionary *)dic;
```

Macro Definition Helper

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

In the end our call can become

```Objective-C
NSString *router = [JLRoutes fk_generateURLWithPattern:FKNavPushRoute parameters:@[NSStringFromClass(ViewController.class)] extraParameters:nil];
[[UIApplication sharedApplication] openURL:JLRGenRouteURL(FKDefaultRouteSchema, router)];
```

----
### 📝 Submission

JianShu Blog：http://www.jianshu.com/p/921dd65e79cb  
Casa Taloyum：https://casatwy.com/modulization_in_action.html  

----
### ⚖ License

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

### 😬 Contributions

* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io
* Code : https://github.com/ReverseScale/OCTemplate

---
# 中文说明

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
