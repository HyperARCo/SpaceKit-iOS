Pod::Spec.new do |spec|
    spec.name               = "SpaceKit"
    spec.version            = "0.0.8111"
    spec.summary            = "SpaceKit iOS"
    spec.description        = "SpaceKit SDK for iOS"
    spec.homepage           = "https://www.dentreality.com"
    spec.documentation_url  = "https://github.com/DentReality/SpaceKit-iOS"
    spec.license            = { :file => 'LICENSE.md' }
    spec.author             = { "SpaceKit" => "Dent Reality" }
    spec.source             = { :git => 'https://github.com/DentReality/SpaceKit-iOS.git', :tag => "#{spec.version}" }
    spec.swift_version      = "5.5"
  
    # Supported deployment targets
    spec.ios.deployment_target  = "13.0"
  
    # Published binaries
    spec.vendored_frameworks = "SpaceKit.xcframework"

    # Dependencies
    spec.dependency 'geos', '~> 7.0.0'
  end
