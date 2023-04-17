#
# Be sure to run `pod lib lint WSNavigationDrawerSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WSNavigationDrawerSwift'
  s.version          = '1.0.0'
  s.summary          = 'A side menu navigation drawer. Easy to use and customize with left & right drawer options.'
  s.swift_version = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'WSNavigationDrawerSwift has Left & Right drawer options. You can integrate nested navigation in drawer as well.'

  s.homepage         = 'https://github.com/WebsoftProfession/WSNavigationDrawerSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WebsoftProfession' => 'websoftprofession@gmail.com' }
  s.source           = { :git => 'https://github.com/WebsoftProfession/WSNavigationDrawerSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'WSNavigationDrawerSwift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WSNavigationDrawerSwift' => ['WSNavigationDrawerSwift/Assets/*.png']
  # }

  s.frameworks = 'UIKit'
  s.swift_versions = '5.0'
end
