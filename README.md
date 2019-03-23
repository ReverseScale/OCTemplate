# OCTemplate

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)  ![](https://img.shields.io/badge/download-6.8MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 

[EN](https://github.com/ReverseScale/OCTemplate) | [中文](https://github.com/ReverseScale/OCTemplate/blob/master/README_zh.md)

Framework Design Based on Objective-C Implementation, YTKNetwork Network + AOP Substitution Base + MVVMC + ReactNative + ReactiveObjC + JLRoutes Components 🤖

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
- (void)requestFinished:(__kindof YTKBase
