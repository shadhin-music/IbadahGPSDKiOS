Pod::Spec.new do |spec|
  # Metadata
 spec.name         = "Ibadah"
  spec.version      = "1.0.0"
  spec.summary      = "An Islamic SDK for MyGP iOS app"
  spec.description  = <<-DESC
    Ibadah provides Islamic content and features for the MyGP iOS app, including prayer times, 
    Quran recitations, and other Islamic functionalities. This SDK helps integrate Islamic 
    features seamlessly into iOS applications.
  DESC
  spec.homepage     = "https://github.com/shadhin-music/IbadahGPSDKiOS"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Talut Mahamud Deep" => "gakkdeep@gmail.com" }
  
  # Platform
  spec.platform     = :ios
  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5.7"
  
  # Source location
  spec.source       = { 
    :git => "https://github.com/shadhin-music/IbadahGPSDKiOS.git", 
    :tag => spec.version.to_s 
  }
  
  # Framework
  spec.ios.vendored_frameworks = "DeenIslamSDK.xcframework"
  
  # Resource bundles
  spec.resource_bundles = {
    'Ibadah' => ['DeenIslamSDK/**/*.{nib,xib,storyboard,xcassets,json,lproj}']
  }
  
  # Build settings
  spec.requires_arc = true
  spec.static_framework = true
  spec.frameworks = 'UIKit'
  
  # Additional configurations to prevent sandbox issues
  spec.pod_target_xcconfig = {
    'SKIP_INSTALL' => 'NO',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    'CODE_SIGNING_ALLOWED' => 'YES',
    'ENABLE_BITCODE' => 'NO'
  }
end