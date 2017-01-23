
Pod::Spec.new do |s|

  s.name         = "VGParallaxHeader.swift"
  s.version      = "1.0.0"
  s.summary      = "You will like it"
  s.homepage     = "https://github.com/huangboju/VGParallaxHeader.swift"
  s.license      = "MIT"
  s.author       = { "huangboju" => "529940945@qq.com" }
  s.platform     = :ios,'8.0'
  s.source       = { :git => "https://github.com/huangboju/VGParallaxHeader.swift.git", :tag => "#{s.version}" }
  s.source_files  = "VGParallaxHeader/Classes/**/*.swift"
  s.framework  = "UIKit"
  s.dependency 'PureLayout'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
