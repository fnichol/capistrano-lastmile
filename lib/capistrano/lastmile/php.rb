module Capistrano
  module Lastmile

    def self.extra_recipes
      %w{
        helpers
        defaults
        php/defaults
        rvm
        bundler
        mysql
        whenever
        mercurial
        git
        multistage
      }
    end

    def self.override_recipes
      %w{
        deploy_stubs
        deploy_extras
        rack/disable_railsisms
      }
    end
  end
end

require "capistrano/lastmile"
