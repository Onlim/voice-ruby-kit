# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "voice_ruby_kit"
  spec.version       = "1.0"
  spec.authors       = ["Richard Dvorsky"]
  spec.email         = ["richard.dvorsky@onlim.com"]
  spec.summary       = %q{Voice Ruby Kit}
  spec.description   = %q{Connector for Amazon Alexa and Google Assistant}
  spec.homepage      = 'https://github.com/onlim/voice-ruby-kit'
  spec.license       = "MIT"
  spec.files         = Dir['[A-Z]*'] + Dir['lib/**/*'] + Dir['tests/**'] + Dir['bin/**']
  spec.files.reject!   { |fn| fn.include? ".gem" }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency 'bundler', '~> 2.0'
  spec.add_runtime_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
  spec.add_development_dependency 'rspec-mocks', '~> 3.2', '>= 3.2.0'
end
