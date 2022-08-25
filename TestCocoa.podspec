#
#  Be sure to run `pod spec lint TestCocoa.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "TestCocoa"
  spec.version      = "0.0.1"
  spec.summary      = "Test for dynamic framework"
  spec.description  = "improve for pull other framework"
  spec.homepage     = "http://EXAMPLE/TestCocoa"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "HiepLe" => "hieplemobile@gmail.com" }
  spec.ios.deployment_target = "10.0"
  
  spec.source = { :http => "https://raw.githubusercontent.com/iOSHiepLe/specs/master/sdk.zip" }

  # spec.subspec 'app_settings' do |s|
  #   s.vendored_frameworks = 'app_settings.xcframework'
  # end
  
  # spec.subspec 'App' do |s|
  #   s.vendored_frameworks = 'App.xcframework'
  # end
  
  # spec.subspec 'beacon' do |s|
  #   s.vendored_frameworks = 'beacon.xcframework'
  # end
  
  # spec.subspec 'contacts_service' do |s|
  #   s.vendored_frameworks = 'contacts_service.xcframework'
  # end
  
  # spec.subspec 'core' do |s|
  #   s.vendored_frameworks = 'core.xcframework'
  # end
  
  # spec.subspec 'DTTJailbreakDetection' do |s|
  #   s.vendored_frameworks = 'DTTJailbreakDetection.xcframework'
  # end
  
  spec.subspec 'FlutterPluginRegistrant' do |s|
    s.ios.vendored_frameworks = 'FlutterPluginRegistrant.xcframework'
  end
  
  # spec.subspec 'FMDB' do |s|
  #   s.vendored_frameworks = 'FMDB.xcframework'
  # end
  
  # spec.subspec 'KeychainSwift' do |s|
  #   s.vendored_frameworks = 'KeychainSwift.xcframework'
  # end
  
  # spec.subspec 'libPhoneNumber_iOS' do |s|
  #   s.vendored_frameworks = 'libPhoneNumber_iOS.xcframework'
  # end
  
  # spec.subspec 'path_provider_ios' do |s|
  #   s.vendored_frameworks = 'path_provider_ios.xcframework'
  # end
  
  # spec.subspec 'safe_device' do |s|
  #   s.vendored_frameworks = 'safe_device.xcframework'
  # end
  
  # spec.subspec 'screenshot_protection' do |s|
  #   s.vendored_frameworks = 'screenshot_protection.xcframework'
  # end
  
  # spec.subspec 'shared_preferences_ios' do |s|
  #   s.vendored_frameworks = 'shared_preferences_ios.xcframework'
  # end
  
  # spec.subspec 'sqflite' do |s|
  #   s.vendored_frameworks = 'sqflite.xcframework'
  # end
  
  # spec.subspec 'url_launcher_ios' do |s|
  #   s.vendored_frameworks = 'url_launcher_ios.xcframework'
  # end
  
  # spec.subspec 'video_player_avfoundation' do |s|
  #   s.vendored_frameworks = 'video_player_avfoundation.xcframework'
  # end
  
  # spec.subspec 'wakelock' do |s|
  #   s.vendored_frameworks = 'wakelock.xcframework'
  # end
  
  # spec.subspec 'wallet_suppression' do |s|
  #   s.vendored_frameworks = 'wallet_suppression.xcframework'
  # end
  
  # spec.subspec 'webview_flutter_wkwebview' do |s|
  #   s.vendored_frameworks = 'webview_flutter_wkwebview.xcframework'
  # end
  
  # #spec.subspec 'Files' do |s|
  #   spec.source_files = 'Tixngo/*.{swift}'
  # #end

  spec.subspec 'Tixngo' do |s| 
    s.source_files = 'Tixngo/*.{swift}'
    s.dependency 'TestCocoa/FlutterPluginRegistrant'
  end
  
  spec.public_header_files = "TestCocoa/**/*.h"
    spec.dependency 'KontaktSDK', '~> 3.0.4'
    spec.dependency 'Flutter'
end

