Pod::Spec.new do |spec|
  spec.name         = "Ibadah"
  spec.version      = "1.0.1"
  spec.summary      = "An Islamic SDK for MyGP iOS app"
  spec.description  = <<-DESC
    Ibadah provides Islamic content and features for the MyGP iOS app, including prayer times, 
    Quran recitations, and other Islamic functionalities.
  DESC
  spec.homepage     = "https://github.com/shadhin-music/IbadahGPSDKiOS"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Talut Mahamud Deep" => "gakkdeep@gmail.com" }
  
  spec.platform     = :ios
  spec.ios.deployment_target = "13.0"
  spec.swift_version = "5.7"
  
  spec.source       = { 
    :git => "https://github.com/shadhin-music/IbadahGPSDKiOS.git", 
    :tag => spec.version.to_s 
  }
  
  # Framework and Resources
  spec.ios.vendored_frameworks = "DeenIslamSDK.xcframework"
  spec.preserve_paths = "DeenIslamSDK.xcframework/**/*"
  
  # Build settings to handle sandbox issues
  spec.pod_target_xcconfig = {
    'SKIP_INSTALL' => 'NO',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    'CODE_SIGNING_ALLOWED' => 'YES',
    'CODE_SIGNING_REQUIRED' => 'NO',
    'CODE_SIGN_IDENTITY' => '',
    'ENABLE_BITCODE' => 'NO',
    'OTHER_LDFLAGS' => '$(inherited) -ObjC'
  }
  
  spec.user_target_xcconfig = {
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    'ENABLE_BITCODE' => 'NO'
  }
  
  spec.requires_arc = true
  spec.static_framework = true
  spec.frameworks = 'UIKit'
end