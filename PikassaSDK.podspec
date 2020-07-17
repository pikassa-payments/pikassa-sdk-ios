Pod::Spec.new do |spec|

  spec.name         = "PikassaSDK"
  spec.version      = "0.1.0-alpha.2"
  spec.license      = "MIT"

  spec.summary      = "Pikassa SDK"
  spec.description  = <<-DESC
					Pikassa SDK
                   DESC
  spec.homepage     = "https://pikassa.io/"
  spec.documentation_url = "https://pikassa.io/"

  spec.author             = { 'PIMPAY KASSA LLC' => 'support@pikassa.io' }

  spec.requires_arc       = true
  spec.source             = { :http => "https://github.com/pikassa-payments/pikassa-sdk-ios/releases/download/#{spec.version}/PikassaSDK.framework.zip" }
  spec.swift_version      = "5.1"
  spec.ios.deployment_target     = '11.0'
  spec.tvos.deployment_target    = '9.0'
  spec.watchos.deployment_target = '2.2'
  spec.vendored_framework = "PikassaSDK.framework"
  spec.preserve_paths = "PikassaSDK.framework"
end
