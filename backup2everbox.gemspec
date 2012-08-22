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
  s.rdoc_options << '--main' << 'README.md' <<
                    '--charset' << 'UTF-8'
  s.extra_rdoc_files = ['README.md', 'History.rdoc']

  s.add_dependency 'backup', '~> 3.0'
  s.add_dependency 'activesupport'
  s.add_dependency 'oauth'
  s.add_dependency 'rest-client'
  s.add_dependency 'launchy'
  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  if (!defined?(RUBY_ENGINE) or RUBY_ENGINE == 'ruby') and RUBY_VERSION > '1.9.1'
    s.add_development_dependency 'debugger'
  end

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
