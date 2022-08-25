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


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "HiepLe" => "hieplemobile@gmail.com" }


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
    spec.ios.deployment_target = "10.0"
    spec.source       = { :git => "https://github.com/iOSHiepLe/TestCocoa.git", :tag => "#{spec.version}" }
    spec.source_files  = "TestCocoa/**/*.{swift}", "TestCocoa/**/*.{m}"
    spec.public_header_files = "TestCocoa/**/*.h"
    #spec.framework = "FlutterPluginRegistrant"
    spec.dependency 'KontaktSDK', '~> 3.0.4'
    spec.dependency 'Flutter'
    spec.dependency 'FlutterPluginRegistrant'
end
