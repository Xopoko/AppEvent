#
#  Be sure to run `pod spec lint AppEvent.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "AppEvent"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of AppEvent."
  spec.description  = <<-DESC
                   DESC
  spec.homepage     = "https://github.com/Xopoko/AppEvent"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "horoko" => "horokko@mail.ru" }
  spec.source       = { :git => "https://github.com/Xopoko/AppEvent" }
  s.source_files = 'Classes/*'
end
