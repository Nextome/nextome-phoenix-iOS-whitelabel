platform :ios, '13.2'

source 'https://github.com/CocoaPods/Specs.git'

plugin 'cocoapods-art', :sources => [
    'nextome-map-cocoapods-local',
    'nextome-sdk-cocoapods-local'
]

target 'nextome-phoenix-iOS-whitelabel' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'BulletinBoard'
  pod 'PhoenixMapUtils_Release'
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
