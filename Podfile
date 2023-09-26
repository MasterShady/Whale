# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Whale' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

	pod 'LookinServer', :configurations => ['Debug']
  pod 'YYKit', git: 'https://github.com/SAGESSE-CN/YYKit.git'
  pod 'Moya/RxSwift'
  pod 'HandyJSON'
  pod 'MBProgressHUD'
  pod 'Kingfisher', '~> 7.8.1'
  pod 'EmptyDataSet-Swift', '~> 5.0.0'
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'FSPagerView', '~> 0.8.3'
  pod 'Toaster'
  pod 'MJRefresh'
  pod 'IQKeyboardManagerSwift', '6.3.0'
  pod 'JXSegmentedView', '~> 1.3.0'
#  pod 'CLImagePickerTool'
  pod 'Cache', '~> 6.0.0'
  pod 'ThinkingSDK','2.8.3.2'
  pod 'ETNavBarTransparent'
  pod 'JXPhotoBrowser', '~> 3.0'
  pod 'CYLTabBarController', '~> 1.24.0'
  pod 'DGCharts'

end

post_install do |installer|
  installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
           end
      end
      
      project.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
        config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      end
    end
end
