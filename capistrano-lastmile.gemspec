# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capistrano-lastmile/version"

Gem::Specification.new do |s|
  s.name        = "capistrano-lastmile"
  s.version     = Capistrano::Lastmile::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Fletcher Nichol"]
  s.email       = ["fnichol@nichol.ca"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "capistrano-lastmile"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
