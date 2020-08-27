Pod::Spec.new do |spec|

  spec.name         = "PikassaSDK"
  spec.version      = "0.1.1"
  spec.license      = "MIT"

  spec.summary      = "Pikassa SDK"
  spec.description  = <<-DESC
					Pikassa SDK
                   DESC
  spec.homepage     = "https://pikassa.io/"
  spec.documentation_url = "https://pikassa.io/"

  spec.author       = { 'PIMPAY KASSA LLC' => 'support@pikassa.io' }

  spec.requires_arc = true
  spec.source       = {
    :git => 'https://github.com/pikassa-payments/pikassa-sdk-ios.git',
    :tag => spec.version.to_s
  }

  spec.source_files = 'Classes/**/*.swift', 'Classes/*.swift'

  spec.swift_version             = "5.1"
  spec.ios.deployment_target     = '11.0'
  spec.tvos.deployment_target    = '9.0'
  spec.watchos.deployment_target = '2.2'
end
