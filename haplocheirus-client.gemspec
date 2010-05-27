# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'haplocheirus/version'

Gem::Specification.new do |s|
  s.name        = "haplocheirus-client"
  s.version     = Haplocheirus::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brandon Mitchell"]
  s.email       = ["brandon@twitter.com"]
  s.summary     = "Haplocheirus Ruby client library"
  s.description = "A Ruby client library for the Haplocheirus store."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_runtime_dependency 'thrift', '>= 0.2.0'
  s.add_runtime_dependency 'thrift_client', '>= 0.4.1'

  s.add_development_dependency 'rspec'

  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.require_path = 'lib'
end
