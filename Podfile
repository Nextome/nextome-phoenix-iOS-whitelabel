# Uncomment the next line to define a global platform for your project
platform :ios, '13.3'

source 'https://github.com/CocoaPods/Specs.git'


plugin 'cocoapods-art', :sources => [
  'nextome-cocoapods-local'
]


def pods
	pod 'NVActivityIndicatorView', '~> 4.8.0'
	pod 'BulletinBoard'
	pod 'SideMenu'
	pod 'PKHUD', '~> 5.0'
	pod 'Firebase/Crashlytics'
	# Recommended: Add the Firebase pod for Google Analytics
	pod 'Firebase/Analytics'

	#NextomeSdk

	pod "PhoenixSdk", :http => 'https://nextome.jfrog.io/artifactory/nextome-cocoapods-local/nextome-sdk.tar.gz', :type => 'tgz' 
	pod "NextomeLegacy", :http => 'https://nextome.jfrog.io/artifactory/nextome-cocoapods-local/nextome-sdk.tar.gz', :type => 'tgz' 

	#MapView

	pod "App_debug", :http => 'https://nextome.jfrog.io/artifactory/nextome-cocoapods-local/flutter-map.tar.gz', :type => 'tgz' 

	pod "Flutter_debug", :http => 'https://nextome.jfrog.io/artifactory/nextome-cocoapods-local/flutter-map.tar.gz', :type => 'tgz' 

	pod "FlutterPluginRegistrant_debug", :http => 'https://nextome.jfrog.io/artifactory/nextome-cocoapods-local/flutter-map.tar.gz', :type => 'tgz' 

	pod "FMDB_debug", :http => 'https://nextome.jfrog.io/artifactory/nextome-cocoapods-local/flutter-map.tar.gz', :type => 'tgz' 

	pod "path_provider_debug", :http => 'https://nextome.jfrog.io/artifactory/nextome-cocoapods-local/flutter-map.tar.gz', :type => 'tgz'

	pod "sqflite_debug", :http => 'https://nextome.jfrog.io/artifactory/nextome-cocoapods-local/flutter-map.tar.gz', :type => 'tgz'

	pod "compass_debug", :http => 'https://nextome.jfrog.io/artifactory/nextome-cocoapods-local/flutter-map.tar.gz', :type => 'tgz'


end

target 'Nextome Indoor Positioning' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Nextome Indoor Positioning
  pods
  
end
