platform :ios, '10.0'
use_frameworks!

def shared_pods
    
    pod 'TapAdditionsKitV2'
    pod 'TapNibViewV2'
    
end

target 'SegmentedControl' do

    shared_pods

end

target 'SegmentedControlExample' do
    
    shared_pods
    
end

post_install do |installer|
    
    installer.pods_project.targets.each do |target|
        
        target.build_configurations.each do |config|
            
            config.build_settings['SWIFT_VERSION'] = '4.1'

        end
    end
end
