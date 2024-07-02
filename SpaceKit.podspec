Pod::Spec.new do |spec|
    spec.name               = "SpaceKit"
    spec.version            = "0.0.9260"
    spec.summary            = "SpaceKit iOS"
    spec.description        = "SpaceKit SDK for iOS"
    spec.homepage           = "https://www.hyperar.com"
    spec.documentation_url  = "https://github.com/HyperARCo/SpaceKit-iOS"
    spec.license            = { :file => 'LICENSE.md' }
    spec.author             = { "SpaceKit" => "Hyper AR" }
    spec.source             = { :git => 'https://github.com/HyperARCo/SpaceKit-iOS.git', :tag => "#{spec.version}" }
    spec.swift_version      = "5.5"
  
    # Supported deployment targets
    spec.ios.deployment_target  = "13.0"
  
    # Published binaries
    spec.vendored_frameworks = "SpaceKit.xcframework"

    # Dependencies
    spec.dependency 'geos', '~> 7.0.0'
    spec.dependency 'lottie-ios', '4.4.3'
  end
