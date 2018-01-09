# OCTemplate
基于 Objective-C 实现的框架设计，YTKNetwork网络层 + AOP替代基类 + MVVM + ReactiveObjC + JLRoutes组件化 🤖

> 我理解的框架，就好比计算机的主板，房屋的建筑骨架，框架搭的好，能直接影响开发者的开发心情，更能让项目健壮性和扩展性大大增强。

![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/80191729.jpg)

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)  ![](https://img.shields.io/badge/download-6.8MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 


### 🤖 要求

* iOS 8.0+
* Xcode 8.0+
* Objective-C


### 🎨 测试 UI 什么样子？

| 名称 |1.展示页 |2.展示页 |3.展示页 |
| ------------- | ------------- | ------------- | ------------- | 
| 截图 | ![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/62454683.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/90202213.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/18-1-9/69076069.jpg) | 
| 描述 | 登录视图 | 示例展示 | 跳转页面 | 


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
```


### 🛠 框架介绍

#### AOP 模式（Aspects-RunTime 代替基类）+ Category 方法交换

采用AOP思想，使用 Aspects 来完成替换 Controller ，View，ViewModel基类，和基类说拜拜

Casa反革命工程师 iOS应用架构谈 view层的组织和调用方案 博客中提到一个疑问
是否有必要让业务方统一派生ViewController
Casa大神回答是NO，原因如下
1. 使用派生比不使用派生更容易增加业务方的使用成本
2. 不使用派生手段一样也能达到统一设置的目的
对于第一点，从 集成成本 ，上手成本 ，架构维护成本等因素入手，大神博客中也已经很详细。

框架不需要通过继承即能够对ViewController进行统一配置。业务即使脱离环境，也能够跑完代码，ViewController一旦放入框架环境，不需要添加额外的或者只需添加少量代码，框架也能够起到相应的作用 对于本人来说 ，具备这点的吸引力，已经足够让我有尝试一番的心思了。

对于OC来说，方法拦截很容易就想到自带的黑魔法方法调配 Method Swizzling， 至于为ViewController做动态配置，自然非Category莫属了
Method Swizzling 业界已经有非常成熟的三方库 Aspects, 所以Demo代码采用 Aspects 做方法拦截。

```Swift
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
至于Category已经非常熟悉了
```Swift
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

#### View层采用 MVVM 设计模式，使用 ReactiveObjC 进行数据绑定

*MVC*
作为老牌思想MVC，大家早已耳熟能详，MVC素有 Massive VC之称，随着业务增加，Controller将会越来越复杂，最终Controller会变成一个"神类", 即有网络请求等代码，又充斥着大量业务逻辑，所以为Controller减负，在某些情况下变得势在必行

*MVVM*
MVVM是基于胖Model的架构思路建立的，然后在胖Model中拆出两部分：Model和ViewModel (注：胖Model 是指包含了一些弱业务逻辑的Model)
胖Model实际上是为了减负 Controller 而存在的，而 MVVM 是为了拆分胖Model , 最终目的都是为了减负Controller。

我们知道，苹果MVC并没有专门为网络层代码分专门的层级，按照以往习惯，大家都写在了Controller 中，这也是Controller 变Massive得元凶之一，现在我们可以将网络请求等诸如此类的代码放到ViewModel中了 （文章后半部分将会描述ViewModel中的网络请求）

*数据流向*
正常的网络请求获取数据，然后更新View自然不必多说，那么如果View产生了数据要怎么把数据给到Model，由于View不直接持有ViewModel，所以我们需要有个桥梁 ReactiveCocoa, 通过 Signal 来和 ViewModel 通信，这个过程我们使用 通知 或者 Target-Action也可以实现相同的效果，只不过没有 ReactiveCocoa 如此方便罢了

```Swift
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

上面代码给出了View -> ViewModel 绑定的一个例子 具体一些详情，可以直接看Demo
MVVM一些总结：
1. View <-> C <-> ViewModel <-> Model 实际上应该称之为MVCVM
2. Controller 将不再直接和 Model 进行绑定，而通过桥梁ViewModel
3. 最终 Controller 的作用变成一些UI的处理逻辑，和进行View和ViewModel的绑定
4. MVVM 和 MVC 兼容
5. 由于多了一层 ViewModel, 会需要写一些胶水代码，所以代码量会增加

#### 网络层使用 YTKNetwork 配合 ReactiveCocoa 封装网络请求，解决如何交付数据，交付什么样的数据（去Model化)等问题
YTKNetwork 是猿题库 iOS 研发团队基于 AFNetworking 封装的 iOS 网络库，其实现了一套 High Level 的 API，提供了更高层次的网络访问抽象。

笔者对 YTKNetwork 进行了一些封装，结合 ReactiveCocoa，并提供 reFormatter 接口对服务器响应数据重新处理，灵活交付给业务层。
接下来，本文会回答两个问题
1. 以什么方式将数据交付给业务层？
2. 交付什么样的数据 ?
对于第一个问题
*以什么方式将数据交付给业务层？*
虽然 iOS应用架构谈 网络层设计方案 中 Casa大神写到 尽量不要用block，应该使用代理
的确，Block难以追踪和定位错误，容易内存泄漏， YTKNetwork 也提供代理方式回调

```Swift
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

```
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

### 📝 深入学习

这里列出了Eureka最基本的操作，Eureka还有更多丰富的功能，如果想要深入学习Eureka，可以前往GitHub-Eureka主页！


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

### 😬 联系

* 微信 : WhatsXie
* 邮件 : ReverseScale@iCloud.com
* 博客 : https://reversescale.github.io
