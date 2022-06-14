Pod::Spec.new do |spec|
    spec.name               = "SpaceKit"
    spec.version            = "0.0.1"
    spec.summary            = "SpaceKit iOS"
    spec.description        = "SpaceKit SDK for iOS"
    spec.homepage           = "https://www.dentreality.com"
    spec.documentation_url  = "https://github.com/DentReality/SpaceKit-iOS"
#    spec.license            = { :type => "MIT" }
    spec.author             = { "SpaceKit" => "Dent Reality" }
    spec.source             = { :git => 'https://github.com/DentReality/SpaceKit-iOS', :tag => "#{spec.version}" }
    spec.swift_version      = "5.6"
  
    # Supported deployment targets
    spec.ios.deployment_target  = "13.0"
  
    # Published binaries
    vendored_frameworks = "SpaceKit.xcframework"
  end