Pod::Spec.new do |s|
  s.name             = 'dash-schema-ios'
  s.version          = '0.1.2'
  s.summary          = 'Dash Schema library'

  s.description      = <<-DESC
Dash Schema library for iOS
                       DESC

  s.homepage         = 'https://github.com/dashevo/dash-schema-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andrew Podkovyrin' => 'podkovyrin@gmail.com' }
  s.source           = { :git => 'https://github.com/dashevo/dash-schema-ios.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/podkovyr'

  s.ios.deployment_target = '10.0'

  s.source_files = 'dash-schema-ios/Classes/**/*'
  
  s.resource_bundles = {
    'dash-schema-ios' => ['dash-schema-ios/Assets/*.json']
  }

  s.dependency 'DSJSONSchemaValidation', '2.0.5'
  s.dependency 'TinyCborObjc', '0.2.1'
end
