# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "backup2everbox/version"

Gem::Specification.new do |s|
  s.name        = "backup2everbox"
  s.version     = Backup2everbox::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["LI Daobing"]
  s.email       = ["lidaobing@gmail.com"]
  s.homepage    = "https://github.com/lidaobing/backup2everbox"
  s.summary     = %q{backup to EverBox}
  s.description = %q{backup to EverBox}

  s.rubyforge_project = "backup2everbox"
  s.rdoc_options << '--main' << 'README.rdoc' <<
                    '--charset' << 'UTF-8'
  s.extra_rdoc_files = ['README.rdoc', 'History.rdoc']

  s.add_dependency 'backup', '~> 2.0'
  s.add_dependency 'activesupport'
  s.add_dependency 'oauth'
  s.add_dependency 'rest-client'
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency 'rake', "0.8.7"
  s.add_development_dependency 'rdoc'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
