# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'miniGram' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for miniGram
  pod 'IQKeyboardManager'
  pod 'ActionKit', '~> 2.5.2'
  pod 'Alamofire'
  pod 'Kingfisher', '~> 7.0'
  pod 'KeychainSwift', '~> 20.0'
  pod 'SwiftyJSON', '~> 4.0'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |bc|
        #bc.build_settings['ARCHS[sdk=iphonesimulator*]'] =  `uname -m`
        bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        #bc.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
    end
  end


end
