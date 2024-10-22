#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_paddle_lite.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_paddle_lite'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.dependency 'OpenCV', '~> 2.4.13'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_paddle_lite_privacy' => ['Resources/PrivacyInfo.xcprivacy']}

#   s.vendored_frameworks = 'Frameworks/opencv2.framework'
  s.vendored_library = 'StaticLib/libpaddle_api_light_bundled.a'
  s.preserve_paths = 'StaticLib/libpaddle_api_light_bundled.a'
  s.private_header_files = 'Headers/Private/*.h'
  s.library = 'c++'
  s.frameworks = 'AVFoundation', 'CoreMedia', 'AssetsLibrary'
end
