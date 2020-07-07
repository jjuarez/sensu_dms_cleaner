# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensu_dms_cleaner/version'

Gem::Specification.new do |spec|
  spec.name          = 'sensu_dms_cleaner'
  spec.version       = SensuDmsCleaner::VERSION
  spec.authors       = ['Javier Juarez']
  spec.email         = ['javier.juarez@gmail.com', 'jjuarez@tuenti.com']

  spec.summary       = 'This is a CLI to help with the clean of Sensu DMS events'
  spec.description   = 'CLI for help you to clean the DMS backups events'
  spec.homepage      = 'https://github.com/jjuarez/sensu_dms_cleaner'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://rubygems.tuenti.int'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor', '~> 0.19'
  spec.add_runtime_dependency 'redis', '~> 3.2'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.53'
end
