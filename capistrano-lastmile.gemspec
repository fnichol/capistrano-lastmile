# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capistrano/lastmile/version"

Gem::Specification.new do |s|
  s.name        = "capistrano-lastmile"
  s.version     = Capistrano::Lastmile::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Fletcher Nichol"]
  s.email       = ["fnichol@nichol.ca"]
  s.homepage    = "http://github.com/fnichol/capistrano-lastmile"
  s.summary     = %q{Take capistrano the last mile to deployment bliss}
  s.description = %q{A collection of recipes and sane defaults for common modern capistrano deployment tasks.}

  s.rubyforge_project = "capistrano-lastmile"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "capistrano",  "~> 2.5.19"
  s.add_dependency "rvm",         ">= 1.0.0"
end
