Pod::Spec.new do |segmentedControl|
    
    segmentedControl.platform = :ios
    segmentedControl.ios.deployment_target = '10.0'
    segmentedControl.name = 'TapSegmentedControlV2'
    segmentedControl.summary = 'Custom Android-style segmented control for iOS'
    segmentedControl.requires_arc = true
    segmentedControl.version = '1.0.0'
    segmentedControl.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.1' }
    segmentedControl.license = { :type => 'MIT', :file => 'LICENSE' }
    segmentedControl.author = { 'Osama Rabie' => 'o.rabie@tap.company' }
    segmentedControl.homepage = 'https://github.com/Tap-Payments/SegmentedControl-iOSV2'
    segmentedControl.source = { :git => 'https://github.com/Tap-Payments/SegmentedControl-iOSV2.git', :tag => segmentedControl.version.to_s }
    segmentedControl.source_files = 'SegmentedControl/Public Classes/*.{swift}', 'SegmentedControl/Internal Classes/*.{swift}'
    segmentedControl.resources = 'SegmentedControl/Resources/*.{xib}'
    
    segmentedControl.dependency 'TapAdditionsKitV2'
    segmentedControl.dependency 'TapNibViewV2'
    
end
