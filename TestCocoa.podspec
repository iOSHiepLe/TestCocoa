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
  spec.source       = { :git => "https://github.com/iOSHiepLe/TestCocoa.git",
                        :tag => "#{spec.version}" }
  spec.source_files  = "TestCocoa/**/*.{swift}", "TestCocoa/**/*.{m}"
  spec.public_header_files = "TestCocoa/**/*.h"
  spec.dependency 'KontaktSDK', '~> 3.0.4'
  spec.dependency 'Flutter'
  spec.frameworks = "app_settings", "FlutterPluginRegistrant", "App", "beacon"
end
