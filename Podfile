# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

def available_pods
  pod 'RxSwift', '5.1.1'
  pod 'Alamofire', '5.0.2'
  pod 'AlamofireImage', '4.0.3'

end

target 'marvelous' do

  # Pods for marvelous
  available_pods

end

target 'marvelousTests' do

  # Pods for marvelousTests
  inherit! :search_paths
  available_pods
  pod 'RxBlocking'
  pod 'RxTest'
  pod 'RxCocoa'

end

target 'marvelousUITests' do

  # Pods for marvelousUITests
  inherit! :search_paths
  available_pods

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "5.0"
        end
    end
end
