Pod::Spec.new do |s|
  s.name         = "ios-jsbridge"
  s.version      = "0.1.0"
  s.summary      = "async javascript bridge via UIWebview"

  s.homepage     = "https://github.com/yamdraco/ios-jsbridge"
  s.license      =  { :type => 'Apache License, Version 2.0' }
  s.author       = { "Draco Yam" => "yamdraco@yahoo.com" }
  s.source       = { :git => "git@github.com:yamdraco/ios-jsbridge.git", :tag => "0.1.0" }
  s.platform     = :ios

  s.source_files  = "Classes/*.{h,m}"
  s.resource  = "Resources/*"
  s.requires_arc = true
  s.dependency "CWLSynthesizeSingleton", "0.0.1"
end
