#
# Be sure to run `pod lib lint KeyboardAvoidingView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KeyboardAvoidingView'
  s.version          = '4.0.0'
  s.summary          = 'View that adjusts it\'s bottom constraint to avoid keyboard'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Common usage: set `KeyboardAvoidingView` class to any view (usually it's base container) that you want to adjust it's bottom constraint or frame height to avoid keyboard.
                       DESC

  s.homepage         = 'https://github.com/APUtils/KeyboardAvoidingView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Plebanovich' => 'anton.plebanovich@gmail.com' }
  s.source           = { :git => 'https://github.com/APUtils/KeyboardAvoidingView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'KeyboardAvoidingView/Classes/**/*'
  s.pod_target_xcconfig = { "DEFINES_MODULE" => "YES" }
  
  # s.resource_bundles = {
  #   'KeyboardAvoidingView' => ['KeyboardAvoidingView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.private_header_files = 'KeyboardAvoidingView/Classes/KeyboardAvoidingViewLoader.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'APExtensions/ViewState', '>= 7.0.0'
end
