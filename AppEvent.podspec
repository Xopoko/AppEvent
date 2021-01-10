#
#  Be sure to run `pod spec lint AppEvent.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = 'AppEvent'
  spec.version      = '0.0.1'
  spec.license      = 'MIT'
  spec.summary      = 'A useful library for handling events in your application'
  spec.homepage     = 'https://github.com/Xopoko/AppEvent'
  spec.author       = 'Рщкщлщ'
  spec.source       = { :git => 'https://github.com/Xopoko/AppEvent.git', :tag => 'v0.0.1' }
  spec.source_files = 'AppEvent/*'
  spec.swift_version = '5.0'
  spec.requires_arc  = true
  spec.ios.deployment_target = '9.0'
end