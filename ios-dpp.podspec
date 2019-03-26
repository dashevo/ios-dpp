Pod::Spec.new do |s|
  s.name             = 'ios-dpp'
  s.version          = '0.0.1'
  s.summary          = 'Dash Platform Protocol'

  s.description      = <<-DESC
The iOS implementation of the Dash Platform Protocol
                       DESC

  s.homepage         = 'https://github.com/dashevo/ios-dpp'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andrew Podkovyrin' => 'podkovyrin@gmail.com' }
  s.source           = { :git => 'https://github.com/dashevo/ios-dpp.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/podkovyr'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ios-dpp/Classes/**/*'
  
  s.resource_bundles = {
    'ios-dpp' => ['ios-dpp/Assets/**/*.json']
  }

  s.module_name = 'DPP'

  s.dependency 'DSJSONSchemaValidation', '2.0.5'
  s.dependency 'TinyCborObjc', '0.3.0'
end
