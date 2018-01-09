# OCTemplate
基于 Objective-C 实现的框架设计，YTKNetwork网络层 + AOP替代基类 + MVVM + ReactiveObjC + JLRoutes组件化

使用 Eureka 让你换个姿势写 Table 🤖

> TableView 应该是项目开发中最常用的部件了，如果你感觉系统的原生方式语法较为‘冗余’，那款三方库一定很适合你。

![](http://og1yl0w9z.bkt.clouddn.com/17-12-18/79869793.jpg)

![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective-C-blue.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)  ![](https://img.shields.io/badge/download-6.8MB-yellow.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 


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

pod 'Eureka'
```

#### 其他操作

另外还需要在Target->工程名->Build Settings->Search Paths->User Header Search Paths处添加Eureka所在的目录：

![](http://og1yl0w9z.bkt.clouddn.com/17-12-18/68332908.jpg)



### 🛠 配置

#### 创建表单

下面来创建一个最简单的表单，表单只包含一个区域和一行，点击该行可以切换到其它页面

```Swift
import UIKit
import Eureka

//ViewController继承于FormViewController
class MyViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //表单form增加一个Section区域，区域名为First form
        form +++ Section("First form")

            //在区域中添加一个ButtonRow（ButtonRow为点击直接触发事件的行），行tag为Rows
            <<< ButtonRow("Rows"){
                //设置行标题为行tag
                $0.title = $0.tag
                //设置点击事件，执行名为"Main"的Segue（需在Interface Builder中自定义）
                $0.presentationMode = .SegueName(segueName: "Main", completionCallback: nil)
        }
              //自定义Row，在后面会讲到
//            <<< WeekDayRow(){
//                $0.value = [.Monday, .Wednesday, .Friday]
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
```

#### 自定义Row

除了使用框架自带的Row，还可以根据自己的需求自定义Row，下面以一个星期选择行为例。首先创建类WeekDayRow.Swift和nib文件WeekDaysCell.xib。

```Swift
import Foundation
import UIKit
import MapKit
import Eureka


//MARK: WeeklyDayCell

public enum WeekDay{
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

public class WeekDayCell : Cell<Set<WeekDay>>, CellType{

    //与nib中的7个按钮建立链接
    @IBOutlet var sundayButton: UIButton!
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!

    //重写cell创建方法
    public override func setup() {
        height = {60}
        row.title = nil
        super.setup()
        selectionStyle = .None

        for subviews in contentView.subviews{
            if let button = subviews as? UIButton{
                //为每个按钮设置选中和未选中时的图片
                button.setImage(UIImage(named: "check.png"), forState: .Selected)
                button.setImage(UIImage(named: "uncheck.png"), forState: .Normal)
                //默认情况下，按钮在被禁用时，图像会被画的颜色淡一些，设置为false是禁止此功能
                button.adjustsImageWhenDisabled = false
                //自定义函数，设置按钮标签与图片的位置
                imageTopTittle(button)
            }
        }
    }

    //重写cell更新方法
    public override func update() {
        row.title = nil
        super.update()
        let value = row.value
        //根据value是否包含某枚举值来设置对应按钮的选中状态
        mondayButton.selected = value?.contains(.Monday) ?? false
        tuesdayButton.selected = value?.contains(.Tuesday) ?? false
        wednesdayButton.selected = value?.contains(.Wednesday) ?? false
        thursdayButton.selected = value?.contains(.Thursday) ?? false
        fridayButton.selected = value?.contains(.Friday) ?? false
        saturdayButton.selected = value?.contains(.Saturday) ?? false
        sundayButton.selected = value?.contains(.Sunday) ?? false

        //设置按钮在不同状态下的透明度
        mondayButton.alpha = row.isDisabled ? 0.6 : 1.0
        tuesdayButton.alpha = mondayButton.alpha
        wednesdayButton.alpha = mondayButton.alpha
        thursdayButton.alpha = mondayButton.alpha
        fridayButton.alpha = mondayButton.alpha
        saturdayButton.alpha = mondayButton.alpha
        sundayButton.alpha = mondayButton.alpha
    }

    //每个按钮的点击事件
    @IBAction func dayTapped(sender : UIButton){
        dayTapped(sender, day: getDayFromButton(sender))
    }

    //根据点击的按钮返回对应的枚举值
    private func getDayFromButton(button : UIButton) -> WeekDay{
        switch button{
        case sundayButton:
            return .Sunday
        case mondayButton:
            return .Monday
        case tuesdayButton:
            return .Tuesday
        case wednesdayButton:
            return .Wednesday
        case thursdayButton:
            return .Thursday
        case fridayButton:
            return .Friday
        default:
            return .Saturday
        }
    }

    //点击改变按钮的选中状态，并从value中插入或删除对应的枚举值
    private func dayTapped(button : UIButton, day:WeekDay){
        button.selected = !button.selected
        if button.selected {
            row.value?.insert(day)
        }
        else{
            row.value?.remove(day)
        }
    }

    //设置按钮标题和图片的位置
    private func imageTopTittle(button : UIButton){
        guard let imageSize = button.imageView?.image?.size else{ return }
        let spacing : CGFloat = 3.0
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
        guard let titleLabel = button.titleLabel, let title = titleLabel.text else{ return }
        let titleSize = title.sizeWithAttributes([NSFontAttributeName: titleLabel.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
    }
}

//MARK: WeekDayRow

public final class WeekDayRow: Row<Set<WeekDay>, WeekDayCell>, RowType{
    //重写init方法
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<WeekDayCell>(nibName: "WeekDaysCell")
    }
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
