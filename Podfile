platform :ios, '13.2'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Nextome/Specs.git'


target 'nextome-phoenix-iOS-whitelabel' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'BulletinBoard'
  pod 'NextomeLocalization', '3.2.3'
  pod 'NextomeMapView_Release', '~> 2.1.5.0'
  pod 'Sheeeeeeeeet'
  pod 'KeychainSwift'
  pod 'Resolver'
  pod 'IQKeyboardManagerSwift'
  pod 'Toast-Swift', '~> 5.0.1'

  # Pods for nextome-phoenix-iOS-whitelabel

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.2'
               end
          end
   end
end
