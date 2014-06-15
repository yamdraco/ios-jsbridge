# Uncomment this line to define a global platform for your project
platform :ios, "7.0"

target "IOS-JSBridge" do
pod 'CWLSynthesizeSingleton', '0.0.1'
end

target "IOS-JSBridgeTests" do
pod 'CWLSynthesizeSingleton', '0.0.1'
end

post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
    end
  end
end