# OCTemplate

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)  ![](https://img.shields.io/badge/download-6.8MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

[EN](https://github.com/ReverseScale/OCTemplate) | [中文](https://github.com/ReverseScale/OCTemplate/blob/master/README_zh.md)

Framework Design Based on Objective-C Implementation, YTKNetwork Network + AOP Substitution Base + MVVM + ReactiveObjC + JLRoutes Components 🤖

> I understand the framework, like the computer's motherboard, building the framework of the building, the infrastructure of the road infrastructure, the framework take a good, can directly affect the developer's development mood, but also make the project robustness and scalability greatly enhanced.

![](https://user-gold-cdn.xitu.io/2018/2/7/1616f69358239a6e?w=820&h=480&f=jpeg&s=46204)

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

![](https://user-gold-cdn.xitu.io/2018/2/7/1616f6935ce5f838?w=198&h=166&f=png&s=36645)

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

![](https://user-gold-cdn.xitu.io/2018/2/7/1616f6935e05933d?w=215&h=172&f=png&s=34900)

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

![](https://user-gold-cdn.xitu.io/2018/2/7/1616f69385b2261c?w=181&h=131&f=png&s=34097)

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

![](https://user-gold-cdn.xitu.io/2018/4/25/162fc3254daa470b?w=468&h=368&f=png&s=37364)

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

