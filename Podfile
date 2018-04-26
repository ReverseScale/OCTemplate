# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'OCTemplate' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  
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
  # 自动卡片布局
  pod 'AutoAlignButtonTools', '~> 0.3.0'
  
  
  # 'node_modules'目录一般位于根目录中
  # 但是如果你的结构不同，那你就要根据实际路径修改下面的`:path`
  pod 'React', :path => './react/node_modules/react-native', :subspecs => [
  'Core',
  'RCTText',
  'RCTNetwork',
  'RCTWebSocket', # 这个模块是用于调试功能的
  # 在这里继续添加你所需要的模块
  ]
  
  # 如果你的RN版本 >= 0.42.0，请加入下面这行
#  pod "Yoga", :path => "./node_modules/react-native/ReactCommon/yoga"


  # Pods for OCTemplate

  target 'OCTemplateTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OCTemplateUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
