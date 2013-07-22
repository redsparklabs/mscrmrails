# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mscrmrails/version'

Gem::Specification.new do |spec|
  spec.name          = "mscrmrails"
  spec.version       = Mscrmrails::VERSION
  spec.authors       = ["Brent Weber"]
  spec.email         = ["bweber@spinuplabs.com"]
  spec.summary       = 'MSCRM 3.0 Connection'
  spec.description   = 'Gem that makes it easier to connect a rails application to a mscrm 3.0 installation.'
  spec.homepage      = "https://github.com/redsparklabs/mscrmrails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  # Dependencies
  spec.add_dependency('savon', '1.2.0') #~>1.2.0')
  spec.add_dependency('json', '>= 0')
  spec.add_dependency('crack', '>= 0')
  spec.add_dependency('hash_extension', '>= 0')
end
