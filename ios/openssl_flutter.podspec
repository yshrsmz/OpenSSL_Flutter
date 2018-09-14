#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'openssl_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  
  s.source_files = 'Classes/**/*'
  s.header_mappings_dir = 'Classes'
  s.public_header_files = 'Classes/**/*.h'
  s.libraries = 'crypto', 'ssl'
  s.vendored_libraries = 'OpenSSL/lib/libssl.a', 'OpenSSL/lib/libcrypto.a'
  s.preserve_paths = 'OpenSSL/module/module.modulemap', 'OpenSSL/include/openssl/*.h'
  s.dependency 'Flutter'
  
  s.pod_target_xcconfig = {
      'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/openssl_flutter/OpenSSL/module $(PODS_TARGET_ROOT)/OpenSSL/module',
      #'HEADER_SEARCH_PATHS' => '$(PODS_ROOT)/openssl_flutter/OpenSSL/include/openssl $(PODS_TARGET_ROOT)/OpenSSL/include/openssl',
      'LIBRARY_SEARCH_PATHS' => '$(PODS_ROOT)/openssl_flutter/OpenSSL/lib  $(PODS_TARGET_ROOT)/OpenSSL/lib'
  }
  
  s.ios.deployment_target = '8.0'
end


