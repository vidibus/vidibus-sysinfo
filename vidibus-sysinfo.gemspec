# -*- encoding: utf-8 -*-
require File.expand_path("../lib/vidibus/sysinfo/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "vidibus-sysinfo"
  s.version     = Vidibus::Sysinfo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Andre Pankratz"
  s.email       = "andre@vidibus.com"
  s.homepage    = "https://github.com/vidibus/vidibus-sysinfo"
  s.summary     = "Provides tools for obtaining information about the system"
  s.description = "Gets CPU usage, current load, consumed memory and some other figures."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "vidibus-sysinfo"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.0.0.beta.20"
  s.add_development_dependency "rr"
  s.add_development_dependency "relevance-rcov"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
